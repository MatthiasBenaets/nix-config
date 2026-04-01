{
  inputs,
  ...
}:

{
  flake.modules.homeManager.flatpak =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

      fonts.fontconfig.enable = true;

      home.packages = [ pkgs.flatpak ];

      services.flatpak = {
        enable = true;
        overrides = {
          global = {
            Context = {
              filesystems = [
                "/nix/store:ro"
              ];
              sockets = [
                "wayland"
                "x11"
                "fallback-x11"
              ];
            };
          };
          "org.freecad.FreeCAD" = {
            Environment = {
              QT_QPA_PLATFORM = "wayland";
            };
          };
        };
        packages = [
          "com.github.tchx84.Flatseal"
          "com.moonlight_stream.Moonlight"
          "com.stremio.Stremio"
          "info.portfolio_performance.PortfolioPerformance"
          "org.freecad.FreeCAD"
          "org.jellyfin.JellyfinDesktop"
        ];
      };
    };
}
