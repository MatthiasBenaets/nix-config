#
#  VNC Remote Connect Server
#

{ config, lib, pkgs, vars, ... }:

{
  config = lib.mkIf (config.services.xserver.enable) {#
    networking.firewall.allowedTCPPorts = [ 5900 ];   # Open Firewall

    environment = {                                   # VNC used for remote access to the desktop
      systemPackages = with pkgs; [
        x11vnc          # VNC Server
      ];
    };

    systemd.services."x11vnc" = {                     # Custom Service
      enable = true;
      description = "VNC Server for X11";
      requires = [ "display-manager.service" ];
      after = [ "display-manager.service" ];
      serviceConfig = {                               # Password stored in document "passwd" at $HOME. This needs auth and link to display. Otherwise x11vnc won't detect the display
        ExecStart = "${pkgs.x11vnc}/bin/x11vnc -passwdfile /home/${vars.user}/passwd -noxdamage -nap -many -repeat -clear_keys -capslock -xkb -forever -loop100 -auth /var/run/lightdm/root/:0 -display :0 -clip 1920x1080+1920+0";
        ExecStop = "${pkgs.x11vnc}/bin/x11vnc -R stop";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
  # passwdfile: Password in /home/{vars.user}/passwd
  # noxdamage: Quicker render (maybe not optimal)
  # nap: If no acitivity, take longer naps
  # many: Keep listening for more connections
  # repeat: X server key auto repeat
  # clear_keys: Clear modifier keys on startup and exit
  # capslock: Don't ignore capslock
  # xkb: Use xkeyboard
  # forever: Keep listening for connection after disconnect
  # loop100: Loop to restart service but wait 100ms
  # auth: X authority file location so vnc also works from display manager (lightdm)
  # display: Which display to show. Even with multiple monitors it's 0
  # clip: Only show specific monitor using xinerama<displaynumber> or pixel coordinates you can find using $ xrandr -q. Can be removed to show all.
}
