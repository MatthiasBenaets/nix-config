{
  flake.modules.editors.nixvim =
    { pkgs, lib, ... }:
    {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          pname = "neocodeium";
          version = "ab8a3da3a66d299ad5422b76ce5ee21b68719296";
          src = pkgs.fetchFromGitHub {
            owner = "monkoose";
            repo = "neocodeium";
            rev = version;
            sha256 = "sha256-rvlTa5nj9Aoelk7taqW5nBSqLZXrLt52jfWc+23toEs=";
          };
          # Require check fails for modules that need network/binaries (false positive)
          doCheck = false;
        })
      ];

      extraConfigLua = ''
        require("neocodeium").setup({
          enabled = true,
          bin = nil,
          manual = false,
          server = {
            api_url = nil,
            portal_url = nil,
          },
          show_label = true,
          debounce = false,
          max_lines = 10000,
          silent = false,
          disable_in_special_buftypes = true,
          log_level = "warn",
          single_line = {
            enabled = false,
            label = "...",
          },
          filter = function(bufnr) return true end,
          filetypes = {
            help = false,
            gitcommit = false,
            gitrebase = false,
            ["."] = false,
          },
          root_dir = { ".bzr", ".git", ".hg", ".svn", "_FOSSIL_", "package.json" }
        })
      '';

      keymaps = [
        {
          mode = "i";
          key = "<C-a>";
          action = {
            __raw = ''
              function()
                require('neocodeium').accept()
              end
            '';
          };
        }
        {
          mode = "i";
          key = "<C-f>";
          action = {
            __raw = ''
              function()
                require('neocodeium').cycle_or_complete()
              end
            '';
          };
        }
        {
          mode = "i";
          key = "<C-c>";
          action = {
            __raw = ''
              function()
                require('neocodeium').clear()
              end
            '';
          };
        }
      ];
    };
}
