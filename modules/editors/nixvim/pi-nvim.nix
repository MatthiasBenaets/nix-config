{
  flake.modules.editors.nixvim =
    {
      config,
      host,
      lib,
      pkgs,
      ...
    }:
    lib.mkIf (builtins.elem "pi" (host.tools or [ ])) {
      # extraPlugins = [
      #   (pkgs.vimUtils.buildVimPlugin rec {
      #     pname = "pi.nvim";
      #     version = "9b619b4f9fb96fa4dc1a6a7776a651980cd819a0";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "pablopunk";
      #       repo = "pi.nvim";
      #       rev = version;
      #       sha256 = "sha256-xtA3Ylu6kB5QF3KJ+4eDDO1PJhcTZVZyS3ei96Hs4bM=";
      #     };
      #   })
      # ];
      #
      # extraConfigLua = ''
      #   require("pi").setup()
      #
      #   vim.keymap.set("n", "<leader>ap", ":PiAsk<CR>", { desc = "Ask pi" })
      #   vim.keymap.set("v", "<leader>ap", ":PiAskSelection<CR>", { desc = "Ask pi (selection)" })
      # '';
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          pname = "pi.nvim";
          version = "3efbe679fdcaac1d643d465eea56826ce335dc4a";
          src = pkgs.fetchFromGitHub {
            owner = "carderne";
            repo = "pi-nvim";
            rev = version;
            sha256 = "sha256-KGUPVXA/a+nTElSxcjngH9Ij/tttDQ48NrYTVg+FSXk=";
          };
        })
      ];

      extraConfigLua = ''
        require("pi-nvim").setup({
          set_default_keymaps = false,
        })

        local Terminal = require("toggleterm.terminal").Terminal
        local pi_term = Terminal:new({
          cmd = "pi",
          direction = "vertical",
          close_on_exit = false,

          on_open = function(term)
            local width = math.floor(vim.o.columns * 0.25)
            vim.api.nvim_win_set_width(term.window, width)
            vim.cmd("startinsert!")
          end,
        })

        vim.keymap.set("n", "<leader>ap", function()
          pi_term:toggle()
        end, { desc = "Toggle Pi coding agent terminal" })

        vim.keymap.set({ "n", "v" }, "<leader>pp", ":Pi\<CR>", {
          desc = "Ask pi",
        })
      '';
    };
}
