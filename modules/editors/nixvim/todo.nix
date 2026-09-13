{
  flake.modules.editors.nixvim =
    { lib, pkgs, ... }:
    {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          # name = "todo.nvim";
          # src = /Users/matthias/Documents/Projects/todo.nvim;
          pname = "todo.nvim";
          version = "45ba3706526cea7eff78cd1de20255abcc834e07";
          src = pkgs.fetchFromGitHub {
            owner = "matthiasbenaets";
            repo = "todo.nvim";
            rev = version;
            sha256 = "sha256-mMaF0MNKOvgbNOVjQ3dKOlWkNtL8tpY7/gI0Mb+MvjY=";
          };
        })
      ];

      keymaps = [
        {
          mode = "n";
          key = "<leader>tt";
          action = ":TodoToggle<CR>";
          options = {
            desc = "Cycle TODO/DONE";
            silent = true;
          };
        }
      ];
    };
}
