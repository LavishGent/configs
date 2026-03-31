---
  Build a Claude Code plugin that wraps a REST API as an MCP (Model Context Protocol) server.
  Users install the plugin into Claude Code and get a set of tools they can invoke conversationally.

  ---

  ## What to Build

  1. An MCP server (Node.js, TypeScript) that wraps a target REST API
  2. A Claude Code plugin that packages and configures the server
  3. A setup command to guide users through authentication
  4. A skill that describes available operations and best practices

  ---

  ## Plugin Structure

  {plugin-root}/
  ├── .claude-plugin/
  │   └── plugin.json
  ├── .mcp.json
  ├── hooks/
  │   hooks.json
  ├── commands/
  │   └── setup.md
  ├── skills/
  │   └── {api-name}-operations/
  │       └── SKILL.md
  ├── src/
  │   ├── index.ts        # MCP server entry point
  │   ├── client.ts       # REST API wrapper
  │   └── tools.ts        # Tool definitions and handlers
  ├── dist/
  │   └── index.js        # Bundled output (committed or built on install)
  ├── package.json
  └── tsconfig.json

  ---

  ## .mcp.json

  Tells Claude Code how to launch the MCP server:

  ```json
  {
    "mcpServers": {
      "{api-name}": {
        "command": "node",
        "args": ["${CLAUDE_PLUGIN_ROOT}/dist/index.js"],
        "env": {
          "{API_TOKEN_ENV_VAR}": "${API_TOKEN_ENV_VAR}"
        }
      }
    }
  }

  - ${CLAUDE_PLUGIN_ROOT} is resolved by Claude Code at runtime to the plugin directory
  - Pass secrets via environment variable forwarding — never hardcode tokens

  ---
  MCP Server (src/index.ts)

  import { Server } from "@modelcontextprotocol/sdk/server/index.js";
  import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
  import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
  import { tools, handleTool } from "./tools.js";
  import { ApiClient } from "./client.js";

  const token = process.env.{API_TOKEN_ENV_VAR};
  if (!token) {
    console.error("Error: {API_TOKEN_ENV_VAR} environment variable is required.");
    console.error("Run /{plugin-name}:setup for instructions.");
    process.exit(1);
  }

  const client = new ApiClient(token);
  const server = new Server({ name: "{api-name}-mcp-server", version: "1.0.0" }, { capabilities: { tools: {} } });

  server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools }));

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    try {
      const result = await handleTool(request.params.name, request.params.arguments ?? {}, client);
      return { content: [{ type: "text", text: result }] };
    } catch (error) {
      return {
        content: [{ type: "text", text: `Error: ${error instanceof Error ? error.message : String(error)}` }],
        isError: true,
      };
    }
  });

  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("{api-name} MCP server running");

  Key points:
  - Stdio transport — server communicates via stdin/stdout; log to stderr only
  - Fail fast if token is missing — provide actionable error message
  - All errors caught at top level and returned as MCP error responses

  ---
  API Client (src/client.ts)

  export class ApiClient {
    constructor(private token: string, private baseUrl = "https://api.{service}.com") {}

    private async request<T>(path: string, options: RequestInit = {}): Promise<T> {
      const response = await fetch(`${this.baseUrl}${path}`, {
        ...options,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json",
          ...options.headers,
        },
      });

      if (response.status === 401) {
        throw new Error("Authentication failed. Check your token and run /{plugin-name}:setup.");
      }
      if (!response.ok) {
        throw new Error(`API error ${response.status}: ${await response.text()}`);
      }
      return response.json() as Promise<T>;
    }

    // One method per logical API operation
    async listItems(params: { page?: number; per_page?: number }) { ... }
    async getItem(id: string) { ... }
    async createItem(data: CreateItemInput) { ... }
  }

  Key points:
  - Wrap every API call — no raw fetch calls in tools.ts
  - Provide helpful error messages for auth failures, referencing the setup command
  - Normalize the base URL (strip trailing slashes, etc.)

  ---
  Tool Definitions (src/tools.ts)

  Use Zod for input validation. Each tool follows this pattern:

  import { z } from "zod";
  import { zodToJsonSchema } from "zod-to-json-schema";

  // --- Schema ---
  const ListItemsSchema = z.object({
    filter: z.string().optional().describe("Filter by keyword"),
    page: z.number().optional().describe("Page number (default: 1)"),
  });

  // --- Handler ---
  async function handleListItems(
    args: z.infer<typeof ListItemsSchema>,
    client: ApiClient
  ): Promise<string> {
    const items = await client.listItems(args);
    if (items.length === 0) return "No items found.";
    return items.map(i => `- **${i.name}** (${i.id}): ${i.description}`).join("\n");
  }

  // --- Tool registry ---
  export const tools = [
    {
      name: "list_items",
      description: "List items with optional filtering",
      inputSchema: zodToJsonSchema(ListItemsSchema),
    },
    // ...
  ];

  export async function handleTool(name: string, args: unknown, client: ApiClient): Promise<string> {
    switch (name) {
      case "list_items": return handleListItems(ListItemsSchema.parse(args), client);
      // ...
      default: throw new Error(`Unknown tool: ${name}`);
    }
  }

  Key points:
  - Return formatted markdown strings — Claude renders them for the user
  - Use descriptive .describe() on every Zod field — this is what Claude sees when deciding how to call the tool
  - Group related tools: list/get/create/update/delete per resource type
  - For large text responses (logs, diffs), truncate with a note: [truncated to last 100 lines]

  ---
  commands/setup.md

  Guide users through one-time auth setup. No frontmatter needed.

  Structure:
  1. What you need (token type, required permission scopes)
  2. How to create the token (link to the service's token settings page)
  3. How to set the environment variable (macOS/Linux shell profile, Windows PowerShell)
  4. How to verify it's set
  5. How to restart Claude Code to pick it up
  6. How to test that it's working
  7. Security best practices (don't commit tokens, minimum required scopes, etc.)

  ---
  skills/{api-name}-operations/SKILL.md

  Reference knowledge for Claude about this API. Frontmatter:

  ---
  name: {api-name}-operations
  description: Reference for {API name} operations, conventions, and best practices
  user-invocable: false
  ---

  Cover:
  - What operations are available (brief overview)
  - Resource ID formats and resolution rules (e.g., short names vs full paths)
  - Pagination conventions
  - Rate limiting considerations
  - Common workflows and the right tool sequence for each
  - What to do when the MCP server isn't available (point to setup command)

  ---
  package.json

  {
    "name": "{org}-{api-name}-mcp-server",
    "version": "1.0.0",
    "type": "module",
    "scripts": {
      "build": "esbuild src/index.ts --bundle --platform=node --format=esm --outfile=dist/index.js
  --banner:js=\"#!/usr/bin/env node\"",
      "prepare": "npm run build"
    },
    "dependencies": {
      "@modelcontextprotocol/sdk": "^1.0.4",
      "zod": "^3.23.8",
      "zod-to-json-schema": "^3.23.0"
    },
    "devDependencies": {
      "@types/node": "^20.0.0",
      "esbuild": "^0.27.0",
      "typescript": "^5.3.0"
    }
  }

  - Bundle to a single dist/index.js — no node_modules needed at runtime
  - npm run prepare auto-builds on install so the plugin works out of the box

  ---
  tsconfig.json

  {
    "compilerOptions": {
      "target": "ES2022",
      "module": "Node16",
      "moduleResolution": "Node16",
      "strict": true,
      "outDir": "dist",
      "declaration": true,
      "sourceMap": true
    },
    "include": ["src"]
  }

  ---
  plugin.json

  {
    "name": "{api-name}-mcp",
    "version": "1.0.0",
    "description": "{API Name} MCP server integration",
    "author": { "name": "{your-team}" },
    "keywords": ["{api-name}", "mcp", "integration"]
  }

  ---
  Design Decisions to Make Before Starting

  1. What resource types does the API have? List them — each becomes a group of tools.
  2. What operations per resource? Typically: list, get, create, update, delete, search.
  3. How does authentication work? PAT, OAuth token, API key, etc.
  4. Are there ID resolution shortcuts? E.g., short name vs full path. Define the rule clearly.
  5. What are the high-value workflows? These should drive which tools to build first.
  6. What are the response size risks? Logs, diffs, and lists can be large — plan truncation.

  ---
  Key Principles

  1. One tool per operation. Don't build a generic "call API" tool.
  2. Return markdown. Format responses so Claude can present them cleanly.
  3. Validate inputs with Zod. Type safety + auto-generated JSON schema for the MCP protocol.
  4. Fail fast on missing auth. Check the token at startup, not at first tool call.
  5. Bundle the server. Users shouldn't need to run npm install — dist/index.js is self-contained.
  6. Helpful error messages. Auth failures should always point to the setup command.

  ---
