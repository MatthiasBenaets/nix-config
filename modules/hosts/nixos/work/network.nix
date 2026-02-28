{
  flake.modules.nixos.work =
    { config, lib, ... }:
    {

      networking = {
        useDHCP = lib.mkDefault true;
        hostName = config.host.name;
        enableIPv6 = false;
        networkmanager.enable = true;
        networkmanager.wifi.scanRandMacAddress = false;
        firewall = {
          # Wireguard trips rpfilter up
          # To load wireguard cert in nm-applet: nmcli connection import type wireguard file <config file>
          extraCommands = ''
            ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
            ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
          '';
          extraStopCommands = ''
            ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
            ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
          '';
          logReversePathDrops = true;

        };
        bridges = {
          "br0" = {
            interfaces = [ "enp0s31f6" ];
          };
        };
        interfaces = {
          enp0s31f6.useDHCP = lib.mkDefault false;
          wlp0s20f3.useDHCP = lib.mkDefault false;
          br0.useDHCP = true;
        };
      };

      systemd.services.NetworkManager-wait-online.enable = false;
    };
}
