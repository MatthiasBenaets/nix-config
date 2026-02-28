{
  flake.modules.nixos.vm =
    {
      config,
      ...
    }:
    {
      networking = {
        useDHCP = false;
        hostName = config.host.name;
        interfaces = {
          enp0s3.useDHCP = true;
        };
      };
    };
}
