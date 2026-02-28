{
  flake.modules.nixos.beelink =
    { config, lib, ... }:
    {
      networking = {
        useDHCP = lib.mkDefault true;
        hostName = config.host.name;
        interfaces = {
          enp1s0.useDHCP = true;
          enp2s0.useDHCP = true;
        };
        enableIPv6 = false;
        defaultGateway = "192.168.0.1";
        nameservers = [
          "192.168.0.4"
          "1.1.1.1"
        ];
        firewall.enable = false;
      };
    };
}
