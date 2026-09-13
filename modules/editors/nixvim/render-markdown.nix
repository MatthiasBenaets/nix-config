{
  flake.modules.editors.nixvim = {
    plugins.render-markdown = {
      enable = true;
      settings = {
        code = {
          sign = false;
        };
        heading = {
          sign = false;
          position = "inline";
          border = true;
        };
        indent = {
          enabled = true;
          skip_heading = true;
        };
      };
    };
  };
}
