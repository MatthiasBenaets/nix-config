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
            ( import ../../modules/desktops/virtualisation ) ++
            ( import ../../modules/hardware/work );

  boot = {                                      # Boot Options
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {                                  # Grub Dual Boot
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;                     # Find All boot Options
        configurationLimit = 2;
        default=2;
      };
      timeout = null;
    };
  };

  laptop.enable = true;                         # Laptop modules
  hyprland.enable = true;                       # Window manager

  hardware = {
    opengl = {                                  # Hardware Accelerated Video
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    sane = {                                    # Scanning
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  environment = {
    systemPackages = with pkgs; [               # System Wide Packages
      ansible           # Automation
      nil               # LSP
      rclone            # Gdrive ($ rclone config | rclone mount --daemon gdrive: <mount> | fusermount -u <mount>)
      simple-scan       # Scanning
      sshpass           # Ansible dependency
      wacomtablet       # Tablet
      wdisplays         # Display Configurator
    ];
  };

  programs.light.enable = true;                 # Monitor Brightness

  flatpak = {                                   # Flatpak Packages (see module options)
    extraPackages = [
      "com.github.tchx84.Flatseal"
    ];
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
