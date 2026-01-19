{ config, lib, system, pkgs, stable, vars, ... }:
let
  nvim-spell-nl-utf8-dictionary = builtins.fetchurl {
    url = "https://ftp.nluug.nl/vim/runtime/spell/nl.utf-8.spl";
    sha256 = "sha256:1v4knd9i4zf3lhacnkmhxrq0lgk9aj4iisbni9mxi1syhs4lfgni";
  };

  nvim-spell-nl-utf8-suggestions = builtins.fetchurl {
    url = "https://ftp.nluug.nl/vim/runtime/spell/nl.utf-8.sug";
    sha256 = "sha256:0clvhlg52w4iqbf5sr4bb3lzja2ch1dirl0963d5vlg84wzc809y";
  };

  livesvelte = pkgs.stdenv.mkDerivation {
    name = "livesvelte";
    version = "v0.16.0";
    buildCommand = ''
      mkdir -p $out/queries/elixir
      cat > $out/queries/elixir/injections.scm << 'EOF'
      ; extends

      ; Svelte
      (sigil
        (sigil_name) @_sigil_name
        (quoted_content) @injection.content
       (#eq? @_sigil_name "V")
       (#set! injection.language "svelte"))
      EOF
    '';
  };
in
{
  programs.nixvim = {
    enable = true;
    enableMan = false;
    viAlias = true;
    vimAlias = true;
    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    extraPackages = with pkgs; [
      black
      eslint_d
      isort
      nixpkgs-fmt
      prettier
      stylua
    ];

    autoCmd = [
      {
        event = "BufWritePre";
        command = "%s/\\s\\+$//e";
        desc = "Remove whitespaces on write";
      }
      {
        event = "FileType";
        pattern = [ "markdown" ];
        callback = {
          __raw = ''
            function()
              vim.cmd("setlocal spell spelllang=en,nl")
              vim.keymap.set("n", "<TAB>", "z=", { noremap = true, silent = true, buffer = true })
            end
          '';
        };
        desc = "Enable spellchecking";
      }
      {
        desc = "Open file at the last position it was edited earlier";
        event = "BufReadPost";
        pattern = "*";
        command = "silent! normal! g`\"zv";
      }
    ];

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      autoindent = true;
      wrap = false;
      scrolloff = 10;
      sidescroll = 20;
      completeopt = [ "menu" "menuone" "noinsert" ];
      pumheight = 15;
      fileencoding = "utf-8";
      swapfile = false;
      undofile = true;
      writebackup = false;
      conceallevel = 0;
      cursorline = true;
      spell = false;
      spelllang = [ "nl" "en" ];
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
      };
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    diagnostic.settings = {
      virtual_text = true;
      signs = true;
      underline = true;
      update_in_insert = true;
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
        mode = "i";
        key = "jk";
        action = "<ESC>";
        options.desc = "Exit Insert Mode";
      }
      {
        key = "<leader>e";
        action = "<CMD>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
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
        key = "<leader>sx";
        action = "<CMD>close<CR>";
        options.desc = "Split Close";
      }
      {
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Select Window Left";
      }
      {
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Select Window Right";
      }
      {
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Select Window Below";
      }
      {
        key = "<C-k>";
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
        action = "<CMD>BufferLinePick<CR>";
        options.desc = "Select Buffer";
      }
      {
        key = "<leader>bk";
        action = "<CMD>BufferLinePickClose<CR>";
        options.desc = "Close Buffer";
      }
      {
        key = "<leader>bn";
        action = "<CMD>BufferLineCycleNext<CR>";
        options.desc = "Next Buffer";
      }
      {
        key = "<leader>bp";
        action = "<CMD>BufferLineCyclePrev<CR>";
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
        key = "gd";
        action = "<CMD>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Show lsp definition in floating window";
      }
      {
        mode = "n";
        key = "gD";
        action = "<CMD>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Load lsp definition in new buffer";
      }
      {
        mode = "n";
        key = "ge";
        action = "<CMD>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Show lsp diagnostic in floating window";
      }
      {
        mode = "n";
        key = "<leader>r";
        action = ":! ";
        options.desc = "Run command";
      }
      {
        mode = "n";
        key = "<TAB>";
        action = "z=";
        options.desc = "Get spell suggestion";
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
        mode = "v";
        key = "p";
        action = "_dP";
        options.desc = "Don't yank pasted over text";
      }
      {
        mode = "n";
        key = "<ESC>";
        action = "<CMD>nohlsearch<CR>";
        options.desc = "Clear highlighting after search";
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
        options.desc = "Center cursor after search";
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options.desc = "Center cursor after search";
      }
      {
        mode = "n";
        key = "<TAB>";
        action = "z=";
        options.desc = "Get spell suggestion";
      }
      {
        mode = "t";
        key = "<ESC>";
        action = "<C-\\><C-n>";
        options.desc = "Escape terminal mode";
      }
      {
        mode = "n";
        key = "<leader>tf";
        action = "<CMD>lua vim.g.disable_autoformat = not vim.g.disable_autoformat; vim.notify('Autoformat ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled'))<CR>";
        options.desc = "Toggle autoformat";
      }
    ];

    highlight = {
      ibl-lines = {
        fg = "#393B42";
      };
    };

    plugins = {
      web-devicons.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      windsurf-vim.enable = true;
      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = false;
          indent.highlight = "ibl-lines";
        };
      };
      nvim-autopairs.enable = true;
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = { text = "+"; };
            change = { text = "~"; };
            delete = { text = "-"; };
            topdelete = { text = "-"; };
            changedelete = { text = "~"; };
            untracked = { text = "x"; };
          };
          signs_staged = {
            add = { text = "+"; };
            change = { text = "~"; };
            delete = { text = "-"; };
            topdelete = { text = "-"; };
            changedelete = { text = "~"; };
            untracked = { text = "x"; };
          };
        };
      };
      fugitive.enable = true;
      markdown-preview.enable = true;
      #otter.enable = if vars.user == "lucp10771" then true else false;
      #quarto.enable = if vars.user == "lucp10771" then true else false;
      comment.enable = true;
      telescope = {
        enable = true;
        settings = {
          pickers.find_files = {
            hidden = true;
          };
        };
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            options = {
              desc = "Find File";
            };
          };
          "<leader>fg" = {
            action = "live_grep";
            options = {
              desc = "Find Via Grep";
            };
          };
          "<leader>fb" = {
            action = "buffers";
            options = {
              desc = "Find Buffers";
            };
          };
          "<leader>fh" = {
            action = "help_tags";
            options = {
              desc = "Find Help";
            };
          };
        };
      };
      neo-tree = {
        enable = true;
        settings = {
          window.width = 35;
          close_if_last_window = true;
          filesystem = {
            filtered_items = {
              visible = true;
            };
          };
        };
      };
      treesitter = {
        enable = true;
        nixvimInjections = true;
        folding.enable = false;
        nixGrammars = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars ++ [ livesvelte ];
        settings = {
          ensure_installed = "all";
          highlight.enable = true;
          incremental_selection.enable = true;
          indent.enable = true;
        };
      };
      colorizer = {
        enable = true;
        settings = {
          user_default_options = {
            css = true;
            tailwind = "both";
          };
        };
      };
      cmp = {
        enable = true;
        settings = {
          snippet.expand = "luasnip";
          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<C-j>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-k>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<C-y>" = "cmp.mapping.confirm({ select = true })";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          formatting = {
            format = ''
              function(entry, vim_item)
                local source_names = {
                  nvim_lsp = "[LSP]",
                  luasnip = "[SNIP]",
                  buffer = "[BUF]",
                  path = "[PATH]",
                }
                vim_item.menu = source_names[entry.source.name] or ""
                return vim_item
              end
            '';
          };
          completion.completeopt = "menu,menuone,noinsert,preview";
        };
      };
      lsp = {
        enable = true;
        servers = {
          lua_ls = {
            enable = true;
            settings = {
              diagnostics = {
                globals = [ "vim" ];
              };
              workspace = {
                checkThirdParty = false;
                telemetry = { enable = false; };
                library = [
                  "\${3rd}/love2d/library"
                ];
              };
            };
          };
          emmet_ls = {
            enable = true;
            filetypes = [
              "html"
              "css"
              "svelte"
              "elixir"
              "eelixir"
              "heex"
            ];
            onAttach = {
              override = true;
              function = ''
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
              '';
            };
          };
          cssls.enable = true;
          elixirls.enable = true;
          eslint.enable = true;
          gopls.enable = true;
          html.enable = true;
          nil_ls = {
            enable = true;
            settings = {
              nix = {
                flake = {
                  autoArchive = true;
                };
              };
              formatting.command = [ "nixpkgs-fmt" ];
            };
          };
          pyright.enable = true;
          svelte.enable = true;
          vue_ls.enable = true;
          tailwindcss = {
            enable = true;
            settings = {
              filetypes = [
                "html"
                "css"
                "js"
                "jsx"
                "mdx"
                "svelte"
                "ts"
                "tsx"
                "heex"
                "elixir"
                "eelixir"
              ];
              includeLanagues = {
                elixir = "html-eex";
                eelixir = "html-eex";
                heex = "html-eex";
              };
              classAttributes = [
                "class"
                "className"
                "class:list"
                "classList"
                "ngClass"
                ''class[:]\s*"([^"]*)"''
              ];
            };
          };
          ts_ls.enable = true;
          # zls.enable = true;
        };
      };
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            svelte = [ "prettier" ];
            vue = [ "prettier" ];
            css = [ "prettier" ];
            html = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
            markdown = [ "prettier" ];
            lua = [ "stylua" ];
            php = [ "prettier" ];
            python = [ "isort" "black" ];
            nix = [ "nixpkgs-fmt" ];
          };
          format_on_save = ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end
              return { timeout_ms = 1000, lsp_fallback = true }, on_format
             end
          '';
        };
      };
      lint = {
        enable = true;
        lintersByFt = {
          javascript = [ "eslint_d" ];
          typescript = [ "eslint_d" ];
          svelte = [ "eslint_d" ];
          python = [ "pylint" ];
        };
      };
      toggleterm = {
        enable = true;
        settings = {
          autoScroll = true;
          closeOnExit = true;
          direction = "horizontal";
          persistMode = true;
          startInInsert = true;
          open_mapping = "[[\\\\]]";
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      luasnip
      livesvelte
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
      # (pkgs.vimUtils.buildVimPlugin rec {
      #   pname = "kanso.nvim";
      #   version = "f67db8dca6d7b5d270188023f129211856d2991c";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "webhooked";
      #     repo = "kanso.nvim";
      #     rev = version;
      #     sha256 = "sha256-5f45q4SvTcmzdCwx76ChyzFg0pKm1ntUgXYbDGhunk8=";
      #   };
      # })
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "vim-plist";
        version = "60e69bec50dfca32f0a62ee2dacdfbe63fd92038";
        src = pkgs.fetchFromGitHub {
          owner = "darfink";
          repo = "vim-plist";
          rev = version;
          sha256 = "sha256-OIMXpX/3YXUsDsguY8/lyG5VXjTKB+k5XPfEFUSybng=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "vim-monkey-c";
        version = "2b3b5df632c4d056c0a9975cf7efed72bf0950cb";
        src = pkgs.fetchFromGitHub {
          owner = "klimeryk";
          repo = "vim-monkey-c";
          rev = version;
          sha256 = "sha256-DVSxJHNrNCxQJNRJqwo6hxLjx22Qe2mWHcmfhFmPTOg=";
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
      -- require("kanso").setup({
      --   undercurl = true,
      --   disableItalics = true,
      --   transparent = true,
      --   dimInactive = false,
      --   terminalColors = true,
      --   theme = "zen",
      --   background = {
      --     dark = "zen",
      --     light = "pearl",
      --   },
      -- })
      -- vim.cmd("colorscheme kanso") --set theme

      vim.o.runtimepath = vim.o.runtimepath .. ',~/.local/share/nvim/site' -- set spellfile path
      vim.opt.fillchars:append({ eob = " " }) -- remove ~ with nothing at end of file
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      deno
      elixir
      erlang
      go
      nodejs
      (python3.withPackages (ps: with ps; [
        pip
      ]))
      ripgrep
      zig
    ];
    variables = {
      PATH = "$HOME/.npm-packages/bin:$PATH";
      NODE_PATH = "$HOME/.npm-packages/lib/node_modules:$NODE_PATH:";
    };
  };

  home-manager.users.${vars.user} = {
    home.file.".local/share/nvim/site/spell/nl.utf-8.spl".source = nvim-spell-nl-utf8-dictionary;
    home.file.".local/share/nvim/site/spell/nl.utf-8.sug".source = nvim-spell-nl-utf8-suggestions;
    home.file.".npmrc".text = "prefix = \${HOME}/.npm-packages";
  };
}
