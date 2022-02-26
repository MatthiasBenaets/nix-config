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
  imports =                                     # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
#   [(import ../../modules/desktop/qemu)] ++              # Virtual Machines
    (import ../../modules/hardware);                      # Hardware devices

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.kernelModules = [ "amdgpu" ];        # Video drivers
    
    loader = {                                  # For legacy boot:
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;                              # Grub auto select time
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    interfaces = {
      enp3s0 = {                                # Change to correct network driver
        # useDHCP = true;
        ipv4.addresses = [ {
          address = "192.168.0.50";
          prefixLength = 24;
        } ];
      };
      wlp2s0.useDHCP = true;
    };
    defaultGateway = "192.168.0.1";
    nameservers = [ "1.1.1.1" ];
  };

  environment = {
    systemPackages = with pkgs; [
      plex
    ];
  };

  services = {
    blueman.enable = true;
    plex = {
      enable = true;
      openFirewall = true;
    };
    xserver = {                                 # In case, multi monitor support
      videoDrivers = [                          # Video Settings
        "amdgpu"
      ];

      displayManager.setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-1 --primary --mode 1920x1080 --rotate normal --output HDMI-A-0 --mode 1920x1080 --rotate normal --left-of HDMI-A-1
      '';
#      xrandrHeads = [                           # Dual screen setting placeholder
#        { output = "HDMI-A-0";
#          primary = true;
#          monitorConfig = ''
#            Option "PreferredMode" "1920x1080"
#            Option "Position" "0 0"
#          '';
#        }
#        { output = "HDMI-A-1";
#          primary = false;
#          monitorConfig = ''
#            Option "PreferredMode" "1920x1080"
#            Option "Position" "0 0"
#          '';
#        } 
#      ];
 
      resolutions = [
        { x = 1920; y = 1080; }
        { x = 1600; y = 900; }
        { x = 3840; y = 2160; }
      ];
    };
  };
}
