{
  flake.modules.editors.nixvim = {
    plugins = {
      notify = {
        enable = true;
        settings = {
          background_colour = "#000000";
        };
      };
    };

  };
}
