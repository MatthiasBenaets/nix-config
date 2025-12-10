#
#  Specific system configuration settings for work
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./work
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktops
#       │   ├─ hyprland.nix
#       │   └─ ./virtualisation
#       │       └─ default.nix
#       └─ ./hardware
#           └─ ./work
#               └─ default.nix
#

{ pkgs, vars, ... }:

{
  imports = [ ./hardware-configuration.nix ] ++
    (import ../../modules/desktops/virtualisation) ++
    (import ../../modules/hardware/work);

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 2;
        default = 2;
      };
      timeout = null;
    };
  };

  laptop.enable = true;
  gnome.enable = true;

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
    ];
  };

  programs.light.enable = true;

  flatpak = {
    extraPackages = [
      "com.github.tchx84.Flatseal"
    ];
  };

  services = {
    syncthing = {
      enable = true;
      user = "${vars.user}";
      dataDir = "/home/${vars.user}/Sync";
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
