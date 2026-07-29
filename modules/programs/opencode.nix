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
      };

      providerConfig =
        if
          builtins.elem host.name [
            "Ubuntu"
            "MacBookAirM1"
            "beelink"
          ]
        then
          {
            ollama = {
              npm = "@ai-sdk/openai-compatible";
              name = "Ollama";
              options.baseURL = "http://192.168.0.40:11434/v1";
              models."qwen3.5:9b" = {
                tools = true;
                reasoning = false;
              };
            };
          }
        else if host.name == "MacBookAirM3" then
          {
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
