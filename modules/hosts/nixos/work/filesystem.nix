{
  flake.modules.nixos.work = {

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/c44a8f5c-1b8e-4c0d-aa63-755a95bd5a50";
      fsType = "ext4";
    };

    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/A101-6404";
      fsType = "vfat";
    };

    fileSystems."/windows" = {
      device = "/dev/disk/by-uuid/01D9316EDB06F490";
      fsType = "ntfs";
      options = [
        "nofail"
        "uid=1000"
        "gid=100"
      ];
    };

    swapDevices = [ ];
  };
}
