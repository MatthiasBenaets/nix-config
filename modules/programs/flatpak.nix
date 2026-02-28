{
  inputs,
  ...
}:

{
  flake.modules.nixos.flatpak =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      xdg.portal = {
        enable = true;
        config.common.default = [ "gtk" ];
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          # xdg-desktop-portal-kde
          # xdg-desktop-portal-wlr
        ];
      };
      fonts.fontDir.enable = true;
      services.flatpak = {
        enable = true;
        overrides = {
          global = {
            Context.filesystems = [
              "/nix/store:ro"
            ];
          };
        };
        packages = [
          "com.github.tchx84.Flatseal"
          "com.stremio.Stremio"
          "info.portfolio_performance.PortfolioPerformance"
        ];
      };
    };
}
