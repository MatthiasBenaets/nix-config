{
  flake.modules.homeManager.opencode =
    {
      host,
      lib,
      osConfig,
      pkgs,
      ...
    }:
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
        "llama.cpp" = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options = {
            baseURL = "http://192.168.0.40:8080/v1";
            apiKey = "{env:LLAMA_API_KEY}";
          };
          models = {
            # "hf.co/unsloth/gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL" = {
            "unsloth/gemma-4-26B-A4B-it-qat-GGUF:Q4_K_XL" = {
              name = "gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL";
              modelID = "gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL";
              tools = true;
            };
            # "hf.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-IQ4_NL" = {
            "unsloth/Qwen3.6-35B-A3B-MTP-GGUF:IQ4_NL" = {
              name = "Qwen3.6-35B-A3B-MTP-GGUF:UD-IQ4_NL";
              modelID = "Qwen3.6-35B-A3B-MTP-GGUF:UD-IQ4_NL";
              tools = true;
            };
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
              options.baseURL = "http://node1.ai.dsi.dhcp.uhasselt.be:8000/v1";
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
        sessionVariables = {
          LLAMA_API_KEY = "$(cat ${osConfig.sops.secrets.llama-api.path})";
        };

        packages = [ pkgs.opencode ];

        file = pkgs.lib.mkIf (providerConfig != null) {
          ".config/opencode/opencode.json".text = builtins.toJSON (
            baseConfig // { provider = providerConfig; }
          );
        };
      };
    };
}
