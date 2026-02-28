{
  flake.modules.nixos.online-account =
    { config, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gnome-control-center
        gnome-online-accounts
      ];

      services.gnome.gnome-keyring.enable = true;

      security.pam.services.gnomekey.enableGnomeKeyring = true;

      home-manager.users.${config.host.user.name} = {
        xdg.desktopEntries.gnome-control-center = {
          name = "Gnome Control Center";
          exec = "env XDG_CURRENT_DESKTOP=GNOME ${pkgs.gnome-control-center}/bin/gnome-control-center";
        };
      };
    };
}
