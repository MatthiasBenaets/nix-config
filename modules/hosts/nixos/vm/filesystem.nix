{
  flake.modules.nixos.vm = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    swapDevices = [ ];
  };
}
