{
  flake.modules.editors.nixvim =
    { lib, pkgs, ... }:
    {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          # name = "blocks.nvim";
          # src = /Users/matthias/Documents/Projects/blocks.nvim;
          pname = "blocks.nvim";
          version = "c2b7afe12fa158d08bc3377d58278d5e74d5e191";
          src = pkgs.fetchFromGitHub {
            owner = "matthiasbenaets";
            repo = "blocks.nvim";
            rev = version;
            sha256 = "sha256-T8KW9+17qCOd7CwWzYIytX/KjOMrYmVDNJcKUNxRGTM=";
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
