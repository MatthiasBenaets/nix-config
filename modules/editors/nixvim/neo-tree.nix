{
  flake.modules.editors.nixvim = {
    plugins = {
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
    };
  };
}
