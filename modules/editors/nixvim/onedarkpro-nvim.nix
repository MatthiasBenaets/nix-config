{
  flake.modules.editors.nixvim =
    { pkgs, ... }:
    {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          pname = "onedarkpro.nvim";
          version = "eeac8847a46a02c4de4e887c4c6d34b282060b5d";
          src = pkgs.fetchFromGitHub {
            owner = "olimorris";
            repo = "onedarkpro.nvim";
            rev = version;
            sha256 = "sha256-c9ZojAJhmwu7PlWSFj3VrHFZx4Gw8Dnza+5fH/p+ppg=";
          };
        })
      ];

      extraConfigLua = ''
        require("onedarkpro").setup({
          options = {
            transparency = true,
          }
        })
        vim.cmd("colorscheme onedark")
      '';
    };
}
