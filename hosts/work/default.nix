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
  hyprland.enable = true;

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
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      ansible # Automation
      ciscoPacketTracer8 # Networking
      eduvpn-client # VPN
      nil # LSP
      obsidian # Notes
      R
      rstudio
      rclone # Gdrive ($ rclone config | rclone mount --daemon gdrive: <mount> | fusermount -u <mount>)
      simple-scan # Scanning
      sshpass # Ansible dependency
      syncthing # Sync Tool
      wacomtablet # Tablet
      vscode
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
