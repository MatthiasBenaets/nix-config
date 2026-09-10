{
  flake.modules.editors.nixvim = {
    plugins.render-markdown = {
      enable = true;
      settings = {
        indent.enabled = true;
      };
    };
  };
}
