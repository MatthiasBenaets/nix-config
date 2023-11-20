{ vars, ... }:

{
  home-manager.users.${vars.user} = {
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };
      
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      maps = {
        normal = {
          "<F2>" = ":NeoTreeShowToggle<CR>";
          "<F3>" = ":UndotreeToggle<CR>";
          "<C-s>" = ":w<CR>";
          "<leader><Left>" = "<C-w>h";
          "<leader>h" = "<C-w>h";
          "<leader><Right>" = "<C-w>l";
          "<leader>l" = "<C-w>l";
        };
      };

      colorschemes.onedark.enable = true;

      options = {
        relativenumber = true;
        number = true;
        hidden = true;
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
        expandtab = true;
        autoindent = true;
        fileencoding = "utf-8";
        swapfile = false;
        completeopt = ["menu" "menuone" "noselect"];
        wrap = false;
      };

      plugins = {
        airline = {
          enable = true;
          powerline = true;
        };
        bufferline.enable = true;
        indent-blankline = {
          enable = true;
          useTreesitter = true;
          useTreesitterScope = true;
          #contextPatternHighlight = true;
        };
        gitgutter.enable = true;
        lastplace.enable = true;
        markdown-preview.enable = true;
        which-key.enable = true;
        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
            "<leader>fb" = "buffers";
            "<leader>fh" = "help_tags";
          };
        };
        neo-tree = {
          enable = true;
          window.width = 30;
        };
        fugitive.enable = true;
        undotree = {
          enable = true;
          focusOnToggle = true;
          highlightChangedText = true;
        };
        treesitter = {
          enable = true;
          nixvimInjections = true;
          folding = false;
          indent = true;
          incrementalSelection.enable = true;
        };
        treesitter-refactor = {
          enable = true;
          highlightDefinitions.enable = true;
          highlightCurrentScope.enable = true;
        };
        lsp = {
          enable = true;
          servers = {
            nil_ls.enable = true;
            #svelte.enable = true;
            html.enable = true;
            tsserver.enable = true;
            tailwindcss = {
              enable = true;
              filetypes = [
                "html"
                "js"
                "ts"
                "jsx"
                "tsx"
                "mdx"
                "svelte"
              ];
            };
          };
        };
        nvim-cmp = {
          enable = true;

          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<Tab>" = {
              modes = ["i" "s"];
              action = "cmp.mapping.select_next_item()";
            };
            "<S-Tab>" = {
              modes = ["i" "s"];
              action = "cmp.mapping.select_prev_item()";
            };
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };

          sources = [
            {name = "path";}
            {name = "nvim_lsp";}
            {
              name = "buffer";
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
          ];
        };
      };
    };
  };
}
