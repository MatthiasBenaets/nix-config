#
#  Specific system configuration settings for beelink
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./beelink
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   ├─ ./hyprland
#       │   │   └─ default.nix
#       │   └─ ./virtualisation
#       │       └─ default.nix
#       └─ ./hardware
#           └─ default.nix
#
# NOTE: Dual booted with windows 11. Disable fast-boot in power plan and bios and turn off hibernate to get wifi and bluetooth working. This only works once but on reboot is borked again. So using the old school BLT dongle.
#
#

{ pkgs, lib, user, ... }:

{
  imports =
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/programs/flatpak.nix)] ++        # Flatpak
    [(import ../../modules/desktop/hyprland/default.nix)] ++ # Window Manager
    [(import ../../modules/hardware/dslr.nix)] ++         # Temp Fix DSLR Webcam
    (import ../../modules/desktop/virtualisation) ++      # Virtual Machines & VNC
    (import ../../modules/hardware);                      # Hardware devices

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                                  # For legacy boot:
      systemd-boot = {
        enable = true;
        configurationLimit = 3;                 # Limit the amount of configurations
      };
      efi = {
	canTouchEfiVariables = true;
      };
      timeout = 5;                              # Grub auto select time
    };
  };

  hardware = {
    sane = {                                    # Used for scanning with Xsane
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [              # Hardware Accelerated Video
        intel-media-driver                      # iHD
        vaapiIntel                              # i965
      ];                                        # Don't forget to set LIBVA_DRIVER_NAME (will often default to i965)
    };                                          # Check which which one will work with 'nix-shell -p libva-utils --run vainfo'
  };

  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.
      discord
      simple-scan
    ];
    variables = {
      LIBVA_DRIVER_NAME = "i965";
    };
  };

  services = {
    blueman.enable = true;                      # Bluetooth
    samba = {                                   # File Sharing over local network
      enable = true;                            # Don't forget to set a password:  $ smbpasswd -a <user>
      shares = {
        share = {
          "path" = "/home/${user}";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
  };

  nixpkgs.overlays = [                          # This overlay will pull the latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "0pml1x6pzmdp6h19257by1x5b25smi2y60l1z40mi58aimdp59ss";
        };}
      );
    })
  ];
}
