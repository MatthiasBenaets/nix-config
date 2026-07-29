{
  flake.modules.editors.nixvim = {
    plugins = {
      snacks.enable = true;
      opencode.enable = true;
    };

    keymaps = [
      {
        mode = [
          "n"
          "x"
        ];
        key = "<C-a>";
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
