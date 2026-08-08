{
  flake.modules.homeManager.opencode =
    { host, pkgs, ... }:
    let
      baseConfig = {
        "$schema" = "https://opencode.ai/config.json";
        permission = {
          edit = "ask";
          bash = "ask";
        };
        lsp = true;
      };

      ollamaProvider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options.baseURL = "http://192.168.0.40:11434/v1";
          models."qwen3.5:9b" = {
            name = "qwen3.5:9b";
            modelID = "qwen3.5:9b";
            tools = true;
          };
          models."hf.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-IQ4_NL" = {
            name = "Qwen3.6-35B-A3B-MTP-GGUF:UD-IQ4_NL";
            modelID = "Qwen3.6-35B-A3B-MTP-GGUF:UD-IQ4_NL";
            options = {
              reasoningEffort = "high";
            };
            tools = true;
          };
          models."hf.co/unsloth/gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL" = {
            name = "gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL";
            modelID = "gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL";
            tools = true;
          };
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
          ollamaProvider
          // {
            vllm = {
              npm = "@ai-sdk/openai-compatible";
              name = "vllm";
              options.baseURL = "http://169.254.215.23:8000/v1";
              models."qwen3.6-27b-nvfp4" = {
                name = "qwen3.6-27b-nvfp4";
                modelID = "qwen3.6-27b-nvfp4";
                think = "high";
                tools = true;
              };
            };
          }
        else
          null;
    in
    {
      home = {
        packages = [ pkgs.opencode ];

        file = pkgs.lib.mkIf (providerConfig != null) {
          ".config/opencode/opencode.json".text = builtins.toJSON (
            baseConfig // { provider = providerConfig; }
          );
        };
      };
    };
}
