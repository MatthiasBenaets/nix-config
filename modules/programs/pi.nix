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
            { id = "gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL"; }
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
          retry = {
            enabled = true;
            maxRetries = 3;
          };
          theme = "dark";
        };
      };

      home = {
        file = pkgs.lib.mkIf (providerConfig != null) {
          ".pi/agent/extensions/confirm-edit.ts".text = ''
            import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

            export default function (pi: ExtensionAPI) {
              pi.on("tool_call", async (event, ctx) => {
                if (!ctx.hasUI) return;

                const toolsToConfirm = ["write", "edit"];
                if (!toolsToConfirm.includes(event.toolName)) return;

                let description = "";
                if (event.toolName === "write") {
                  const path = (event.input as any)?.path;
                  description = `Write to $\{path}`;
                } else if (event.toolName === "edit") {
                  const path = (event.input as any)?.path;
                  description = `Edit $\{path}`;
                }

                const ok = await ctx.ui.confirm("File Change", `$\{description}?\nAllow this change?`);
                if (!ok) {
                  return { block: true, reason: "Blocked by user" };
                }
              });
            }
          '';
        };
      };
    };
}
