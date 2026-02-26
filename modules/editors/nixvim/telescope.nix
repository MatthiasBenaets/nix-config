{
  flake.modules.editors.nixvim = {
    plugins = {
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
    };
  };
}
