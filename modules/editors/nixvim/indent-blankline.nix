{
  flake.modules.editors.nixvim = {
    highlight = {
      ibl-lines = {
        fg = "#393B42";
      };
    };

    plugins = {
      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = false;
          indent.highlight = "ibl-lines";
        };
      };
    };
  };
}
