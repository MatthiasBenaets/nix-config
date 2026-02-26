{
  flake.modules.editors.nixvim =
    { lib, pkgs, ... }:
    {
      enableMan = false;
      viAlias = true;
      vimAlias = true;

      opts = {
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
        expandtab = true;
        autoindent = true;
        wrap = false;
        scrolloff = 10;
        sidescroll = 20;
        completeopt = [
          "menu"
          "menuone"
          "noinsert"
        ];
        pumheight = 15;
        fileencoding = "utf-8";
        swapfile = false;
        undofile = true;
        writebackup = false;
        conceallevel = 0;
        cursorline = true;
        spell = false;
        spelllang = [
          "nl"
          "en"
        ];
      };

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy = lib.mkIf pkgs.stdenv.isLinux {
          enable = true;
        };
      };

      diagnostic.settings = {
        virtual_text = true;
        signs = true;
        underline = true;
        update_in_insert = true;
      };
    };
}
