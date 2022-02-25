#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./qemu
#               └─ default.nix
#

{ config, pkgs, ... }:

{
  imports =                                 # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
#   (import ../../modules/desktop/qemu) ++                # Virtual Machines
    (import ../../modules/hardware);                      # Hardware devices

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.kernelModules = [ "amdgpu" ];       # Video drivers
    
    loader = {                                  # For legacy boot:
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;                              # Grub auto select time
    };
  };

  networking = {
    hostName = "nixos";
    interfaces = {
      enp3s0.useDHCP = true;                    # Change to correct network driver.
      wlp2s0.useDHCP = true;
    };
  };

  services.dbus.packages = with pkgs;[          # No DisplayManager so enable services here.
    polybar
    dunst
  ];

  services = {
    blueman.enable = true;
    xserver = {                                 # In case, multi monitor support
      videoDrivers = [                          # Video Settings
        "amdgpu"
      ];

#     xrandrHeads = [                           # Dual screen setting placeholder
#       { output = "HDMI-A-0";
#         primary = true;
#         monitorConfig = ''
#           Modeline "3840x2160_30.00"  338.75  3840 4080 4488 5136  2160 2163 2168 2200 -hsync +vsync
#           Option "PreferredMode" "3840x2160_30.00"
#           Option "Position" "0 0"
#         '';
#       }
#       { output = "eDP";
#         primary = false;
#         monitorConfig = ''
#           Option "PreferredMode" "1920x1080"
#           Option "Position" "0 0"
#         '';
#       }
#     ];
#
      resolutions = [
        { x = 1920; y = 1080; }
        { x = 1600; y = 900; }
        { x = 3840; y = 2160; }
      ];
    };
  };
}
