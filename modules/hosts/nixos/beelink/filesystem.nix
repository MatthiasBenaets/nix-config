{
  flake.modules.nixos.beelink =
    { config, ... }:
    let
      smbOptions = [
        "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
        "mfsymlinks"
        "uid=1000"
        "gid=100"
        "credentials=/home/${config.host.user.name}/smb"
      ];
    in
    {

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/045641c5-b7de-468b-979f-565b1ee56803";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/94BB-A907";
        fsType = "vfat";
      };

      swapDevices = [ ];

      fileSystems."/storage" = {
        device = "//192.168.0.3/storage";
        fsType = "cifs";
        options = smbOptions;
      };

      fileSystems."/media" = {
        device = "//192.168.0.3/media";
        fsType = "cifs";
        options = smbOptions;
      };
    };
}
