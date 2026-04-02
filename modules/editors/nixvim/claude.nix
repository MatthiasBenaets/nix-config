{
  flake.modules.editors.nixvim =
    { host, ... }:
    {
      plugins.claude-code = {
        enable = true;
        settings = {
          window = {
            split_ratio = 0.3;
            enter_insert = true;
            hide_number = true;
            hide_signcolumn = true;
            position = "vertical";
            # float = {
            #   width = "80%";
            #   height = "80%";
            # };
          };
        };
      };
      extraConfigLua = ''
        vim.env.ANTHROPIC_BASE_URL = "${
          if host.name == "Ubuntu" then
            "http://192.168.0.40:11434"
          else if host.name == "MacBookAirM3" then
            "http://simlab-d1.dhcp.uhasselt.be"
          else
            "https://api.anthropic.com"
        }"
        vim.env.ANTHROPIC_AUTH_TOKEN = "ollama"
        vim.env.ANTHROPIC_MODEL = "qwen3.5:9b"
        vim.env.CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1"
      '';
    };
}
