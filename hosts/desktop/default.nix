#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   └─ ./bspwm
#       │       └─ bspwm.nix
#       └─ ./desktop
#           └─ ./qemu
#               └─ default.nix
#

{ config, pkgs, lib, user, ... }:

{
  imports =                                     # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/bspwm/bspwm.nix)] ++   # Window Manager
    [(import ../../modules/apps/steam.nix)] ++            # VNC Server
    [(import ../../modules/desktop/virtualisation/x11vnc.nix)] ++ # VNC Server
    [(import ../../modules/services/media.nix)] ++        # Media Center
    (import ../../modules/desktop/virtualisation) ++      # Virtual Machines
    (import ../../modules/hardware);                      # Hardware devices

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.kernelModules = [ "amdgpu" ];        # Video drivers
    
    loader = {                                  # For legacy boot:
      systemd-boot = {
        enable = true;
        configurationLimit = 5;                 # Limit the amount of configurations
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;                              # Grub auto select time
    };
  };

  hardware.sane = {                           # Used for scanning with Xsane
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.
      discord
      plex
      simple-scan
      x11vnc
      wacomtablet
    ];
  };

  services = {
    blueman.enable = true;                      # Bluetooth
    printing = {                                # Printing and drivers for TS5300
      enable = true;
      drivers = [ pkgs.cnijfilter2 ];           # There is the possibility cups will complain about missing cmdtocanonij3. I guess this is just an error that can be ignored for now.
    };
    avahi = {                                   # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {                               # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
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
    plex = {                                    # Plex Server
      enable = true;
      openFirewall = true;
    };
    xserver = {                                 # In case, multi monitor support
      videoDrivers = [                          # Video Settings
        "amdgpu"
      ];

      modules = [ pkgs.xf86_input_wacom ];      # Both needed for wacom tablet usage
      wacom.enable = true;

      displayManager.sessionCommands = ''
        #!/bin/sh
        SCREEN=$(${pkgs.xorg.xrandr}/bin/xrandr | grep " connected " | wc -l)
        if [[ $SCREEN -eq 1 ]]; then
          ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-1 --primary --mode 1920x1080 --rotate normal
        elif [[ $SCREEN -eq 2 ]]; then
          ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-1 --primary --mode 1920x1080 --rotate normal --output DisplayPort-1 --mode 1920x1080 --rotate normal --left-of HDMI-A-1
        elif [[ $SCREEN -eq 3 ]]; then
          ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-1 --primary --mode 1920x1080 --rotate normal --output DisplayPort-1 --mode 1920x1080 --rotate normal --left-of HDMI-A-1 --output HDMI-A-0 --mode 1280x1024 --rotate normal --right-of HDMI-A-1
        fi
      '';                                       # Settings for correct display configuration; This can also be done with setupCommands when X server start for smoother transition (if setup is static)
                                                # Another option to research in future is arandr
      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
      '';                                       # Used so computer does not goes to sleep

      resolutions = [
        { x = 1920; y = 1080; }
        { x = 1600; y = 900; }
        { x = 3840; y = 2160; }
      ];
    };
  };

  nixpkgs.overlays = [                          # This overlay will pull the latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz"; 
          sha256 = "0hdgif8jpp5pz2c8lxas88ix7mywghdf9c9fn95n0dwf8g1c1xbb";
        };}
      );
    })
  ];
}
