{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    options = {
      number = true;
      relativenumber = true;
      hidden = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      autoindent = true;
      wrap = false;
      completeopt = ["menu" "menuone" "noselect"];
      pumheight = 15;
      fileencoding = "utf-8";
      swapfile = false;
    };

    colorschemes.onedark.enable = true;

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      {
        key = "<C-s>";
        action = "<CMD>w<CR>";
        options.desc = "Save";
      }
      {
        key = "<F2>";
        action = "<CMD>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
      }
      {
        key = "<F3>";
        action = "<CMD>UndotreeToggle<CR>";
        options.desc = "Toggle Undotree";
      }
      {
        key = "<leader><Left>";
        action = "<C-w>h";
        options.desc = "Select Window Left";
      }
      {
        key = "<leader>h";
        action = "<C-w>h";
        options.desc = "Select Window Left";
      }
      {
        key = "<leader><Right>";
        action = "<C-w>l";
        options.desc = "Select Window Right";
      }
      {
        key = "<leader>l";
        action = "<C-w>l";
        options.desc = "Select Window Right";
      }
      {
        key = "<leader>b";
        action = "<CMD>BufferLinePick<CR>";
        options.desc = "View Open Buffer";
      }
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options.desc = "Tab Text Right";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options.desc = "Tab Text Left";
      }
    ];

    plugins = {
      lualine.enable = true;
      bufferline.enable = true;
      gitgutter.enable = true;
      indent-blankline = {
        enable = true;
        scope.enabled = true;
      };
      lastplace.enable = true;
      comment-nvim.enable = true;
      fugitive.enable = true;
      markdown-preview.enable = true;
      nvim-autopairs.enable = true;
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
      };
      nvim-colorizer.enable = true;
      neorg = {
        enable = true;
        modules = {
          "core.defaults" = { };
          "core.dirman".config.workspaces.home = "~";
          "core.completion".config.engine = "nvim-cmp";
          "core.norg.concealer" = { };
          "core.norg.journal" = { };
        };
      };
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          svelte.enable = true;
          html.enable = true;
          cssls.enable = true;
          tsserver.enable = true;
          pyright.enable = true;
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
      lspkind = {
        enable = true;
        cmp = {
          enable = true;
          menu = {
            nvim_lsp = "[LSP]";
            nvim_lua = "[api]";
            path = "[path]";
            luasnip = "[snip]";
            buffer = "[buffer]";
          };
        };
      };
      luasnip.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      nvim-cmp = {
        enable = true;
        snippet.expand = "luasnip";
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
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "path";}
          {name = "buffer";}
          {name = "nvim_lua";}
          {name = "orgmode";}
        ];
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      luasnip
      friendly-snippets
      orgmode
    ];
    extraConfigLua = ''
      require("luasnip.loaders.from_vscode").lazy_load()
      require('orgmode').setup({
        org_agenda_files = { '~/org/**/*' },
        org_default_notes_file = '~/org/refile.org',
      })
    '';
    extraConfigLuaPre = ''
      require('orgmode').setup_ts_grammar()
    '';
  };
}
