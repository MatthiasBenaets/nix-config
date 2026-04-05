{
  flake.modules.homeManager.claude =
    {
      config,
      host,
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
          ANTHROPIC_AUTH_TOKEN = "ollama";
          ANTHROPIC_BASE_URL = "${
            if host.name == "Ubuntu" || host.name == "MacBookAirM1" || host.name == "beelink" then
              "http://192.168.0.40:11434"
            else if host.name == "MacBookAirM3" then
              "http://simlab-d1.dhcp.uhasselt.be"
            else
              "https://api.anthropic.com"
          }";
          ANTHROPIC_MODEL = "qwen3.5:9b";
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
