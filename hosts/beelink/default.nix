#
#  Specific system configuration settings for beelink
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./beelink
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ hyprland.nix
#           └─ ./virtualisation
#               └─ default.nix
#
#  NOTE: Dual booted with windows 11. Disable fast-boot in power plan and bios and turn off hibernate to get wifi and bluetooth working. This only works once but on reboot is borked again. So using the old school BLT dongle.
#

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/programs/games.nix
  ] ++
  (import ../../modules/desktops/virtualisation);

  # Boot Options
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
      efi = {
        canTouchEfiVariables = true;
      };
      timeout = 5;
    };
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  # hyprland.enable = true;
  niri.enable = true;

  environment = {
    systemPackages = with pkgs; [
      # gmtp # Mount GoPro
      go2tv # Casting
      google-cloud-sdk-gce # Google Cloud
      jellyfin-desktop # Media Player
      moonlight-qt # Remote Streaming
      obs-studio # Live Streaming
      orca-slicer # 3D Slicer
      portfolio # Stocks
      simple-scan # Scanning
    ];
  };

  flatpak = {
    extraPackages = [
      "com.github.tchx84.Flatseal"
      "com.ultimaker.cura"
      "com.stremio.Stremio"
    ];
  };
}
