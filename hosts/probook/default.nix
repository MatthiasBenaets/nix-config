#
#  Specific system configuration settings for probook
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./probook
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ bspwm.nix
#           └─ ./virtualisation
#               └─ docker.nix
#

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktops/virtualisation/docker.nix
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 2;
      };
      timeout = 1;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  laptop.enable = true;
  bspwm.enable = true;

  environment = {
    systemPackages = with pkgs; [
      simple-scan # Scanning
    ];
  };

  programs.light.enable = true;

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.cnijfilter2 ]; # Canon TS5300
    };
  };

  flatpak = {
    extraPackages = [
      "com.github.tchx84.Flatseal"
    ];
  };

  # Temporary Bluetooth Fix
  systemd.tmpfiles.rules = [
    "d /var/lib/bluetooth 700 root root - -"
  ];
  systemd.targets."bluetooth".after = [ "systemd-tmpfiles-setup.service" ];
}
