{
  flake.modules.editors.nixvim =
    { lib, pkgs, ... }:
    {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          # name = "blocks.nvim";
          # src = /Users/matthias/Documents/Projects/blocks.nvim;
          pname = "blocks.nvim";
          version = "648d04109fc368eae6e496e74acc7e601abd55a4";
          src = pkgs.fetchFromGitHub {
            owner = "matthiasbenaets";
            repo = "blocks.nvim";
            rev = version;
            sha256 = "sha256-ZHQncyH9UFg2gxh47eFJVMEVi5qtrecrCaeDgf3ybfQ=";
          };
        })
      ];

      extraConfigLua = ''
        require("blocks").setup({
          prefix = "",
          interpreters = {
            ruby = "ruby",
            js = { "node", "--input-type=module" },
            go = function(code)
              local tmp = vim.fn.tempname() .. ".go"
              vim.fn.writefile(vim.split(code, "\n"), tmp)
              local output = vim.fn.system({ "go", "run", tmp })
              vim.fn.delete(tmp)
              if vim.v.shell_error == 0 then
                return vim.trim(output)
              end
            end,
          },
        })
      '';
    };
}
