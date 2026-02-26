{
  flake.modules.editors.nixvim = {
    plugins = {
      toggleterm = {
        enable = true;
        settings = {
          autoScroll = true;
          closeOnExit = true;
          direction = "horizontal";
          persistMode = true;
          startInInsert = true;
          open_mapping = "[[\\\\]]";
        };
      };
    };
  };
}
