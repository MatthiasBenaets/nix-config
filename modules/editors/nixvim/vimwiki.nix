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

    keymaps = [
      {
        mode = "n";
        key = "<leader>tc";
        action = ":VimwikiToggleListItem<CR>";
        options = {
          desc = "Toggle checkbox";
          silent = true;
        };
      }
    ];
  };
}
