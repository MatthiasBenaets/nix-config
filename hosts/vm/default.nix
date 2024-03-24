#
#  Specific system configuration settings for vm
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./vm
#   │       ├─ default.nix *
#   │       └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           └─ bspwm.nix
#

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
      };
      timeout = 1;
    };
  };

  bspwm.enable = true;

  environment = {
    systemPackages = with pkgs; [
      hello # Hello World
    ];
  };

  services = {
    xserver = {
      resolutions = [
        { x = 1920; y = 1080; }
        { x = 1600; y = 900; }
        { x = 3840; y = 2160; }
      ];
    };
  };
}
