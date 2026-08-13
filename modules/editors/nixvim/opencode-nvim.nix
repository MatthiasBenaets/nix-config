{
  flake.modules.editors.nixvim =
    {
      config,
      host,
      lib,
      ...
    }:
    lib.mkIf (builtins.elem "opencode" (config.host.tools or [ ])) {
      plugins = {
        snacks.enable = true;
        opencode = {
          enable = true;
          settings = {
            server.start.__raw = ''
              function()
                require("snacks.terminal").open("opencode --port", {
                  win = {
                    position = "right",
                    enter = false,
                  },
                })
              end
            '';
          };
        };
      };

      keymaps = [
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>ao";
          action.__raw = ''function() require("opencode").ask("@this: ") end'';
          options.desc = "Ask OpenCode...";
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<C-x>";
          action.__raw = ''function() require("opencode").select() end'';
          options.desc = "Select OpenCode prompt...";
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "go";
          action.__raw = ''function() return require("opencode").operator("@this ") end'';
          options = {
            expr = true;
            desc = "Append range to OpenCode";
          };
        }
        {
          mode = "n";
          key = "goo";
          action.__raw = ''function() return require("opencode").operator("@this ") .. "_" end'';
          options = {
            expr = true;
            desc = "Append line to OpenCode";
          };
        }
        {
          mode = "n";
          key = "<S-C-u>";
          action.__raw = ''function() require("opencode").command("session.half.page.up") end'';
          options.desc = "Scroll OpenCode up";
        }
        {
          mode = "n";
          key = "<S-C-d>";
          action.__raw = ''function() require("opencode").command("session.half.page.down") end'';
          options.desc = "Scroll OpenCode down";
        }
      ];
    };
}
