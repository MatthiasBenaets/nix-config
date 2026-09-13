{
  flake.modules.editors.nixvim =
    { lib, pkgs, ... }:
    {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          # name = "todo.nvim";
          # src = /Users/matthias/Documents/Projects/todo.nvim;
          pname = "todo.nvim";
          version = "15a1eb4075793527d05a691cc641eb4bed8508f7";
          src = pkgs.fetchFromGitHub {
            owner = "matthiasbenaets";
            repo = "todo.nvim";
            rev = version;
            sha256 = "sha256-A8fKVCbPN++UVr8Mgm3jQjMqLD2IyS7TnfALvHONc7g=";
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
