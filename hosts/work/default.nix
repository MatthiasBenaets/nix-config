#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./work
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   ├─ ./hyprland
#       │   │   └─ default.nix
#       │   └─ ./virtualisation
#       │       └─ default.nix
#       └─ ./hardware
#           ├─ default.nix
#           └─ ./work
#               └─ default.nix
#

{ pkgs, lib, user, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/gnome/default.nix)] ++ # Window Manager
    (import ../../modules/desktop/virtualisation) ++      # Virtual Machines & VNC
    (import ../../modules/hardware) ++                    # Hardware devices
    (import ../../modules/hardware/work);                 # Hardware specific quirks

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    #initrd.kernelModules = [ "amdgpu" ];       # Video drivers

    loader = {                                  # EFI Boot
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      #systemd-boot = {
      #  enable = true;
      #  configurationLimit = 5;                 # Limit the amount of configurations
      #};
      grub = {                                  # Most of grub is set up for dual boot
        enable = true;
        version = 2;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;                     # Find all boot options
        configurationLimit = 2;
        default=2;
      };
      timeout = null;                           # Grub auto select time
    };
  };

  hardware = {
    sane = {                                    # Used for scanning with Xsane
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        # intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.
      nil
      simple-scan
      x11vnc
      wacomtablet
    ];
    variables = {
      LIBVA_DRIVER_NAME = "i965";
    };
  };

  programs = {                                  # No xbacklight, this is the alterantive
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    #tlp.enable = true;                          # TLP and auto-cpufreq for power management
    auto-cpufreq.enable = true;
    blueman.enable = true;                      # Bluetooth
    avahi = {                                   # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {                               # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    # samba = {                                   # File Sharing over local network
    #   enable = true;                            # Don't forget to set a password:  $ smbpasswd -a <user>
    #   shares = {
    #     share = {
    #       "path" = "/home/${user}";
    #       "guest ok" = "yes";
    #       "read only" = "no";
    #     };
    #   };
    #   openFirewall = true;
    # };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
