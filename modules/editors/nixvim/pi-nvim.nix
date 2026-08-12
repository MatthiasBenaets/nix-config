{
  flake.modules.editors.nixvim =
    {
      host,
      lib,
      pkgs,
      ...
    }:
    lib.mkIf (builtins.elem "pi" host.tools) {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          pname = "pi.nvim";
          version = "9b619b4f9fb96fa4dc1a6a7776a651980cd819a0";
          src = pkgs.fetchFromGitHub {
            owner = "pablopunk";
            repo = "pi.nvim";
            rev = version;
            sha256 = "sha256-xtA3Ylu6kB5QF3KJ+4eDDO1PJhcTZVZyS3ei96Hs4bM=";
          };
        })
      ];

      extraConfigLua = ''
        require("pi").setup()

        vim.keymap.set("n", "<leader>ap", ":PiAsk<CR>", { desc = "Ask pi" })
        vim.keymap.set("v", "<leader>ap", ":PiAskSelection<CR>", { desc = "Ask pi (selection)" })
      '';
    };
}
