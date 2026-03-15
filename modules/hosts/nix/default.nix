{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.preferXdgDirectories = true;

      targets.genericLinux = {
        enable = true;
        gpu = {
          enable = true;
        };
      };

      xdg = {
        enable = true;
        mime.enable = true;
      };
    };
}
