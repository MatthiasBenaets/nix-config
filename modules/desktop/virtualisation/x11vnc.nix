{ pkgs, user, ... }:

{
  networking.firewall.allowedTCPPorts = [ 5900 ];   # Since x11vpn defaults to port 5900. Open this port in firewall

  environment = {                                   # VNC used for remote access to the desktop
    systemPackages = with pkgs; [
      x11vnc
    ];
  };

  systemd.services."x11vnc" = {                     # Made into a custom service
    enable = true;
    description = "VNC Server for X11";
    requires = [ "display-manager.service" ];
    after = [ "display-manager.service" ];
    serviceConfig = {                               # Password is stored in document passwd at $HOME. This needs auth and link to display. Otherwise x11vnc won't detect the display
      ExecStart = "${pkgs.x11vnc}/bin/x11vnc -passwdfile /home/${user}/passwd -nap -many -repeat -loop -clear_keys -capslock -xkb -forever -auth /var/run/lightdm/root/:0 -display :0";
      ExecStop = "${pkgs.x11vnc}/bin/x11vnc -R stop";
    };
    wantedBy = [ "multi-user.target" ];
  };
} 
