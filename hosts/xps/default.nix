#
#  Specific system configuration settings for xps
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./xps
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ hyprland.nix
#           └─ ./virtualisation
#               └─ docker.nix
#

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktops/virtualisation/docker.nix
  ] ++ (import ../../modules/hardware/xps);

  boot = {
    consoleLogLevel = 3;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 2;
      };
      efi = {
        canTouchEfiVariables = true;
      };
      timeout = 5;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  laptop.enable = true;
  hyprland.enable = true;

  environment = {
    systemPackages = with pkgs; [
      fprintd # Fingerprint
      jellyfin-media-player # Media Player
      plex-media-player # Media Player
      simple-scan # Scanning
      moonlight-qt # Remote Streaming
    ];
  };

  services = {
    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    }; # $ sudo fprintd-enroll --finger right-index-finger <user>
    logind.extraConfig = ''
      HandlePowerKey=ignore
    ''; # Disable short click powerbutton
    hardware.bolt.enable = true;
  };

  programs.light.enable = true;

  flatpak = {
    extraPackages = [
      "com.github.tchx84.Flatseal"
      "com.stremio.Stremio"
    ];
  };
}
