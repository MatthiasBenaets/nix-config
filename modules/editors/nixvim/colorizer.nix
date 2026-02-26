{
  flake.modules.editors.nixvim = {
    plugins.colorizer = {
      enable = true;
      settings = {
        user_default_options = {
          css = true;
          tailwind = "both";
        };
      };
    };
  };
}
