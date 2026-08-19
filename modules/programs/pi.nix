{
  flake.modules.homeManager.pi =
    { host, pkgs, ... }:
    let
      ollamaProvider = {
        ollama = {
          baseUrl = "http://192.168.0.40:8080/v1";
          api = "openai-completions";
          apiKey = "key";
          models = [
            # { id = "gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL"; }
            # { id = "Qwen3.6-35B-A3B-MTP-GGUF:UD-IQ4_NL"; }
            { id = "unsloth/gemma-4-26B-A4B-it-qat-GGUF:Q4_K_XL"; }
            { id = "unsloth/Qwen3.6-35B-A3B-MTP-GGUF:IQ4_NL"; }
          ];
        };
      };

      vllmProvider = {
        vllm = {
          baseUrl = "http://node1.ai.dsi.dhcp.uhasselt.be:8000/v1";
          api = "openai-completions";
          apiKey = "key";
          models = [
            { id = "qwen3.6-27b-nvfp4"; }
          ];
        };
      };

      providerConfig =
        if
          builtins.elem host.name [
            "Ubuntu"
            "MacBookAirM1"
            "beelink"
          ]
        then
          ollamaProvider
        else if host.name == "MacBookAirM3" then
          ollamaProvider // vllmProvider
        else
          null;
    in
    {
      programs.pi-coding-agent = {
        enable = true;
        extraPackages = with pkgs; [
          nodejs
        ];
        context = ''
          ## General
          - Be concise and practical.
          - Prefer small, focused changes.
          - Avoid unrelated refactors.

          ## Workflow
          1. Read relevant files before editing.
          2. Explain intent briefly.
          3. Make the smallest change that solves the task.
          4. Validate with tests/commands when available.

          ## Code quality
          - Keep naming clear and code readable.
          - Update docs when behavior changes.
          - Preserve existing style unless asked otherwise.

          ## Safety
          - Do not delete or run destructive commands unless explicitly requested.
          - Ask befoer making broad or risky changes.

          ## Uncertainty and errors
          - If you are unsure of an answer, encounter an error you can't immediately resolve, or get stuck on a task, do not guess or make assumptions. Instead:
            1. Check if an available MCP tool or extension can provide the needed information or resolve the issue directly.
            2. If no MCP tool fits, use web_search to look up current, authoritative information before answering.
            3. Only fall back to stating your own best guess if both of the above fail to resolve the uncertainty and clearly flag it as a guess when you do.
          - Do not silently proceed with unverified assumptions, especially for anything involving current facts, tool usage, error messages, or configuration syntax.

          ## Tools
          - Every `web_search` tool call must include `numResults: 10` as a parameter. Always pass it explicitly, regardless of query type or how many sources seem sufficient.

          ## Notes
          - Repository-local `AGENTS.md` files can add or override project-specific guidance.
        '';
        models.providers = providerConfig;
        settings = {
          compaction = {
            enabled = true;
            keepRecentTokens = 20000;
            reserveTokens = 16384;
          };
          defaultProvider =
            if
              builtins.elem host.name [
                "Ubuntu"
                "MacBookAirM1"
                "beelink"
              ]
            then
              "ollama"
            else if host.name == "MacBookAirM3" then
              "vllm"
            else
              "";
          defaultModel =
            if
              builtins.elem host.name [
                "Ubuntu"
                "MacBookAirM1"
                "beelink"
              ]
            then
              "gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL"
            else if host.name == "MacBookAirM3" then
              "qwen3.6-27b-nvfp4"
            else
              "";
          defaultProjectTrust = "ask";
          defaultThinkingLevel = "high";
          enableAnalytics = false;
          packages = [
            "npm:pi-mcp-adapter"
            "npm:pi-web-access"
            "npm:@gotgenes/pi-permission-system"
          ];
          retry = {
            enabled = true;
            maxRetries = 3;
          };
          theme = "dark";
        };
      };

      home = {
        file = pkgs.lib.mkIf (providerConfig != null) {
          ".pi/web-search.json".text = ''
            {
              "provider": "searxng",
              "searxngBaseUrl": "http://127.0.0.1:8080",
              "ssrf": {
                "allowRanges": ["127.0.0.1/32"]
              },
              "workflow": "none",
                "searchRouting": {
              "providers": ["searxng", "duckduckgo"],
                "fallbackOn": ["transient", "network"]
              }
            }
          '';
        };
      };
    };
}
