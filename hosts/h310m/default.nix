#
#  Specific system configuration settings for h310m
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./h310m
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ hyprland.nix
#           └─ ./virtualisation
#               └─ default.nix
#

{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ] ++
    (import ../../modules/desktops/virtualisation);

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    initrd.kernelModules = [ "amdgpu" ];
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
      driSupport = true;
      driSupport32Bit = true;
    };
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  hyprland.enable = true;

  environment = {
    systemPackages = with pkgs; [
      ansible # Automation
      gmtp # Used for mounting gopro
      plex-media-player # Media Player
      simple-scan # Scanning
      sshpass # Ansible Dependency
      wacomtablet # Tablet
    ];
  };

  flatpak = {
    extraPackages = [
      "com.github.tchx84.Flatseal"
    ];
  };
}
