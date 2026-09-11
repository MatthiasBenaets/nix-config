{
  flake.modules.editors.nixvim = {
    plugins.vimwiki = {
      enable = true;
      settings = {
        list = [
          {
            ext = ".md";
            path = "~/Documents/codex";
            syntax = "markdown";
          }
        ];
      };
    };
  };
}
