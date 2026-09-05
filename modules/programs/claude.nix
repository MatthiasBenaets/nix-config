{
  flake.modules.homeManager.claude =
    {
      config,
      host,
      osConfig,
      pkgs,
      ...
    }:
    {
      home = {
        packages = with pkgs; [
          master.claude-code
        ];
        sessionVariables = {
          ANTHROPIC_API_KEY = "";
          ANTHROPIC_AUTH_TOKEN =
            if host.name == "Ubuntu" || host.name == "MacBookAirM1" || host.name == "beelink" then
              "$(cat ${osConfig.sops.secrets.llama-api.path})"
            else if host.name == "MacBookAirM3" then
              "$(cat ${osConfig.sops.secrets.work-vllm-api.path})"
            else
              "";
          ANTHROPIC_BASE_URL = "${
            if host.name == "Ubuntu" || host.name == "MacBookAirM1" || host.name == "beelink" then
              "http://192.168.0.40:11434"
            else if host.name == "MacBookAirM3" then
              "http://node1.ai.dsi.dhcp.uhasselt.be:8000/v1"
            else
              "https://api.anthropic.com"
          }";
          ANTHROPIC_MODEL =
            if host.name == "Ubuntu" || host.name == "MacBookAirM1" || host.name == "beelink" then
              "unsloth/Qwen3.6-35B-A3B-MTP-GGUF:IQ4_NL"
            else if host.name == "MacBookAirM3" then
              "unsloth/Qwen3.8-27B-NVFP4"
            else
              "";
          CLAUDE_CODE_ATTRIBUTION_HEADER = "0";
          CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
          DISABLE_TELEMETRY = "1";
        };
      };

      # Alternative:
      # - Use the command line flag:
      #   ANTHROPIC_AUTH_TOKEN="ollama" ANTHROPIC_BASE_URL="http://localhost:11434" claude --model qwen3.5:9b
      # - Set `~/.claude/settings.json` as
      #   {
      #     "theme": "dark",
      #     "primaryModel": "qwen3.5:9b",
      #     "env": {
      #       "ANTHROPIC_BASE_URL": "http://localhost:11434",
      #       "ANTHROPIC_AUTH_TOKEN": "ollama",
      #       "ANTHROPIC_API_KEY": "",
      #       "CLAUDE_CODE_ATTRIBUTION_HEADER": "0",
      #       "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
      #       "DISABLE_TELEMETRY": "1"
      #     }
      #   }
    };
}
