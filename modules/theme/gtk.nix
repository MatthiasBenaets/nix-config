{
  flake.modules.homeManager.mime =
    {
      config,
      ...
    }:
    {
      gtk.gtk4.theme = config.gtk.theme;
    };
}
