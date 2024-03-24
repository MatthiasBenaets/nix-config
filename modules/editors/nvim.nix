{ pkgs, ... }:

let
  colors = import ../theming/colors.nix;

  dutch = builtins.readFile (builtins.fetchurl {
    url = "https://raw.githubusercontent.com/OpenTaal/opentaal-wordlist/master/wordlist.txt";
    sha256 = "1gnpkb2afasbcfka6lhnpzlpafpns4k6j09h7dc0p13k7iggpr8j";
  });
in
{
  # # steam-run for codeium-vim
  # # start nvim in bash first time, so the spell files can be downloaded
  # programs.zsh.shellAliases = {
  #   vim = "${pkgs.steam-run}/bin/steam-run nvim";
  #   nvim = "${pkgs.steam-run}/bin/steam-run nvim";
  # };
  environment = {
    systemPackages = with pkgs; [
      go
      nodejs
      python3
      ripgrep
      zig
    ];
    wordlist = {
      enable = true;
      lists = {
        WORDLIST = [
          "${pkgs.scowl}/share/dict/words.txt"
          (builtins.toFile "dutch" dutch)
        ];
      };
    };
  };
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    autoCmd = [
      {
        event = "VimEnter";
        command = "set nofoldenable";
        desc = "Unfold All";
      }
      {
        event = "BufWrite";
        command = "%s/\\s\\+$//e";
        desc = "Remove Whitespaces";
      }
      {
        event = "FileType";
        pattern = [ "markdown" "org" "norg" ];
        command = "setlocal conceallevel=2";
        desc = "Conceal Syntax Attribute";
      }
      {
        event = "FileType";
        pattern = [ "markdown" "org" "norg" ];
        command = "setlocal spell spelllang=en,nl";
        desc = "Spell Checking";
      }
      {
        event = "FileType";
        pattern = [ "markdown" "org" "norg" ];
        command = ":TableModeEnable";
        desc = "Table Mode";
      }
      {
        event = "FileType";
        pattern = [ "markdown" ];
        command = "setlocal scrolloff=30 | setlocal wrap";
        desc = "Fixed cursor location on markdown (for preview) and enable wrapping";
      }
    ];

    options = {
      number = true;
      relativenumber = true;
      hidden = true;
      foldlevel = 99;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      autoindent = true;
      wrap = false;
      scrolloff = 5;
      sidescroll = 40;
      completeopt = [ "menu" "menuone" "noselect" ];
      pumheight = 15;
      fileencoding = "utf-8";
      swapfile = false;
      timeoutlen = 2500;
      conceallevel = 3;
      cursorline = true;
    };

    colorschemes.onedark = {
      enable = true;
      package = pkgs.vimPlugins.onedarkpro-nvim;
    };

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
        key = "<leader>q";
        action = "<CMD>q<CR>";
        options.desc = "Quit";
      }
      {
        key = "<F2>";
        action = "<CMD>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
      }
      {
        key = "<leader>e";
        action = "<CMD>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
      }
      {
        key = "<leader>fs";
        action = "<CMD>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
      }
      {
        key = "<F3>";
        action = "<CMD>UndotreeToggle<CR>";
        options.desc = "Toggle UndoTree";
      }
      {
        key = "<leader>sh";
        action = "<C-w>s";
        options.desc = "Split Horizontal";
      }
      {
        key = "<leader>sv";
        action = "<C-w>v";
        options.desc = "Split Vertical";
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
        key = "<leader><Down>";
        action = "<C-w>j";
        options.desc = "Select Window Below";
      }
      {
        key = "<leader>j";
        action = "<C-w>j";
        options.desc = "Select Window Below";
      }
      {
        key = "<leader><Up>";
        action = "<C-w>k";
        options.desc = "Select Window Above";
      }
      {
        key = "<leader>k";
        action = "<C-w>k";
        options.desc = "Select Window Above";
      }
      {
        key = "<leader>t";
        action = "<C-w>w";
        options.desc = "Cycle Between Windows";
      }
      {
        key = "<leader>bb";
        action = "<CMD>BufferPick<CR>";
        options.desc = "Select Buffer";
      }
      {
        key = "<leader>bc";
        action = "<CMD>BufferClose<CR>";
        options.desc = "Close Current Buffer";
      }
      {
        key = "<leader>bk";
        action = "<CMD>BufferClose<CR>";
        options.desc = "Close Current Buffer";
      }
      {
        key = "<leader>bn";
        action = "<CMD>:bnext<CR>";
        options.desc = "Next Buffer";
      }
      {
        key = "<leader>bp";
        action = "<CMD>:bprev<CR>";
        options.desc = "Previous Buffer";
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
      {
        mode = "n";
        key = "<C-/>";
        action = "<Plug>(comment_toggle_linewise_current)";
        options.desc = "(Un)comment in Normal Mode";
      }
      {
        mode = "v";
        key = "<C-/>";
        action = "<Plug>(comment_toggle_linewise_visual)";
        options.desc = "(Un)comment in Visual Mode";
      }
      {
        mode = "n";
        key = "<C-S-/>";
        action = "<Plug>(comment_toggle_blockwise_current)";
        options.desc = "(Un)comment in Normal Mode";
      }
      {
        mode = "v";
        key = "<C-S-/>";
        action = "<Plug>(comment_toggle_blockwise_visual)";
        options.desc = "(Un)comment in Visual Mode";
      }
      {
        mode = "n";
        key = "gd";
        action = "<CMD>lua vim.lsp.buf.hover()<CR>";
      }
      {
        mode = "n";
        key = "gD";
        action = "<CMD>lua vim.lsp.buf.definition()<CR>";
      }
      {
        mode = "n";
        key = "ge";
        action = "<CMD>lua vim.diagnostic.open_float()<CR>";
      }
      {
        mode = "n";
        key = "<leader>r";
        action = ":! ";
      }
      {
        mode = "n";
        key = "<TAB>";
        action = "z=";
      }
    ];

    plugins = {
      lualine.enable = true;
      barbar.enable = true;
      gitgutter = {
        enable = true;
        defaultMaps = false;
      };
      mini = {
        enable = true;
        modules = {
          indentscope = { };
          move = { };
        };
      };
      indent-blankline.enable = true;
      lastplace.enable = true;
      comment-nvim.enable = true;
      fugitive.enable = true;
      markdown-preview.enable = true;
      nvim-autopairs.enable = true;
      telescope = {
        enable = true;
        extraOptions = {
          pickers.find_files = {
            hidden = true;
          };
        };
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            desc = "Find File";
          };
          "<leader>fg" = {
            action = "live_grep";
            desc = "Find Via Grep";
          };
          "<leader>fb" = {
            action = "buffers";
            desc = "Find Buffers";
          };
          "<leader>fh" = {
            action = "help_tags";
            desc = "Find Help";
          };
        };
      };
      neo-tree = {
        enable = true;
        window.width = 30;
        closeIfLastWindow = true;
        extraOptions = {
          filesystem = {
            filtered_items = {
              visible = true;
            };
          };
        };
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
        nixGrammars = true;
        ensureInstalled = "all";
        incrementalSelection.enable = true;
      };
      treesitter-refactor = {
        enable = true;
      };
      nvim-colorizer = {
        enable = true;
        userDefaultOptions = {
          css = true;
          tailwind = "both";
        };
      };
      cursorline = {
        enable = true;
        cursorline = {
          enable = true;
          number = true;
          timeout = 0;
        };
        cursorword = {
          enable = true;
          hl = { underline = true; };
          minLength = 3;
        };
      };
      neorg = {
        enable = true;
        lazyLoading = true;
        modules = {
          "core.defaults".__empty = null;
          "core.dirman".config = {
            workspaces = {
              notes = "~/notes";
            };
            default_workspace = "notes";
          };
          "core.concealer".__empty = null;
          "core.completion".config.engine = "nvim-cmp";
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
          gopls.enable = true;
          zls.enable = true;
        };
      };
      lsp-format.enable = true;
      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources = {
          formatting = {
            nixpkgs_fmt.enable = true;
            markdownlint.enable = true;
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
            look = "[look]";
            buffer = "[buffer]";
            orgmode = "[orgmode]";
            neorg = "[neorg]";
          };
        };
      };
      lsp-lines.enable = true;
      luasnip.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-look.enable = true;
      nvim-cmp = {
        enable = true;
        snippet.expand = "luasnip";
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          # "<Tab>" = {
          #   modes = ["i" "s"];
          #   action = "cmp.mapping.select_next_item()";
          # };
          # "<S-Tab>" = {
          #   modes = ["i" "s"];
          #   action = "cmp.mapping.select_prev_item()";
          # };
          "<Down>" = {
            modes = [ "i" "s" ];
            action = "cmp.mapping.select_next_item()";
          };
          "<Up>" = {
            modes = [ "i" "s" ];
            action = "cmp.mapping.select_prev_item()";
          };
          "<C-j>" = {
            modes = [ "i" "s" ];
            action = "cmp.mapping.select_next_item()";
          };
          "<C-k>" = {
            modes = [ "i" "s" ];
            action = "cmp.mapping.select_prev_item()";
          };
          # "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping.confirm({ select = true })";
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "look"; keywordLength = 2; option = { convert_case = true; loud = true; }; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "nvim_lua"; }
          { name = "orgmode"; }
          { name = "neorg"; }
        ];
      };
      which-key = {
        enable = true;
        registrations = {
          "<leader>b" = "+Buffer";
          "<leader>f" = "+Find";
          "<leader>o" = "+Org Mode";
          "<leader>s" = "+Split Window";
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      friendly-snippets
      luasnip
      nvim-scrollbar
      orgmode
      vim-cool
      vim-prettier
      vim-table-mode
      # codeium-vim
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "scope-nvim";
        version = "cd27af77ad61a7199af5c28d27013fb956eb0e3e";
        src = pkgs.fetchFromGitHub {
          owner = "tiagovla";
          repo = "scope.nvim";
          rev = version;
          sha256 = "sha256-z1ytdhxKrLnZG8qMPEe2h+wC9tF4K/x6zplwnIojZuE=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "org-bullets.nvim";
        version = "6e0d60e901bb939eb526139cb1f8d59065132fd9";
        src = pkgs.fetchFromGitHub {
          owner = "akinsho";
          repo = "org-bullets.nvim";
          rev = version;
          sha256 = "sha256-x6S4WdgfUr7HGEHToSDy3pSHEwOPQalzWhBUipqMtnw=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "follow-md-links.nvim";
        version = "cf081a0a8e93dd188241a570b9a700b6a546ad1c";
        src = pkgs.fetchFromGitHub {
          owner = "jghauser";
          repo = "follow-md-links.nvim";
          rev = version;
          sha256 = "sha256-ElgYrD+5FItPftpjDTdKAQR37XBkU8mZXs7EmAwEKJ4=";
        };
      })
    ];
    extraConfigLua = ''
      require('luasnip.loaders.from_vscode').lazy_load()
      require('orgmode').setup({
        org_agenda_files = { '~/org/**/*' },
        org_default_notes_file = '~/org/refile.org',
      })
      vim.cmd[[
        augroup orgmode_settings
          autocmd!
          autocmd FileType org
          \ setlocal conceallevel=2 |
          \ setlocal concealcursor=nc
        augroup END
      ]]

      require('org-bullets').setup()

      require('scrollbar').setup()
    '';
    extraConfigLuaPre = with colors.scheme.default.hex; ''
      require('orgmode').setup_ts_grammar()
      require('onedarkpro').setup({
        colors = {
          bg = "#${bg}",
        },
        options = {
          cursorline = true,
        },
      })
    '';
  };
}
