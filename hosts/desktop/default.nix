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
    [(import ../../modules/services/media.nix)] ++        # Media Center
    [(import ../../modules/desktop/virtualisation/x11vnc.nix)] ++
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

  networking = {
    hostName = "nixos";
    #networkmanager.enable = true;
    interfaces = {
      enp3s0 = {                                # Change to correct network driver
        # useDHCP = true;                       # Disabled because fixed ip
        ipv4.addresses = [ {                    # Ip settings: *.0.50 for main machine
          address = "192.168.0.50";
          prefixLength = 24;
        } ];
      };
      #wlp2s0.useDHCP = true;                   # Wireless card
    };
    defaultGateway = "192.168.0.1";
    nameservers = [ "1.1.1.1" ];                # Cloudflare
  };

  environment = {                               # Packages installed system wide
    #extraInit = ''
    #  snixembed --fork
    #'';                                        # Fixes some tray icons
    systemPackages = with pkgs; [               # This is because some options need to be configured.
      discord
      plex
      x11vnc
    ];
  };

  programs = {                                  # Needed to succesfully start Steam
    steam.enable = true;
    gamemode.enable = true;                     # Better gaming performance
                                                # Steam: Right-click game - Properties - Launch options: gamemoderun %command%
                                                # Lutris: General Preferences - Enable Feral GameMode
                                                #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
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

  #hardware.sane = {                           # Used for scanning with Xsane
  #  enable = true;
  #  #extraBackends = [ pkgs.cnijfilter2 ];
  #  extraBackends = [ pkgs.sane-airscan ];
  #};

  services = {
    blueman.enable = true;                      # Bluetooth
    printing = {                                # Printing and drivers for TS5300
      enable = true;
      drivers = [ pkgs.cnijfilter2 ];
    };
    avahi = {                                   # Needed to find wireless printer
      enable = true;
      nssmdns = true;
    };
    plex = {                                    # Plex Server
      enable = true;
      openFirewall = true;
    };
    #xrdp = {
    #  enable = true;
    #  defaultWindowManager = "${pkgs.bspwm}/bin/bspwm";
    #  port = 3389;
    #  openFirewall = true;
    #};
    xserver = {                                 # In case, multi monitor support
      videoDrivers = [                          # Video Settings
        "amdgpu"
      ];

      displayManager.sessionCommands = ''
        #!/bin/sh
        SCREEN=$(${pkgs.xorg.xrandr}/bin/xrandr | grep " connected " | wc -l)
        if [[ $SCREEN -eq 1 ]]; then
          ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-1 --primary --mode 1920x1080 --rotate normal
        elif [[ $SCREEN -eq 2 ]]; then
          ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-1 --primary --mode 1920x1080 --rotate normal --output HDMI-A-0 --mode 1920x1080 --rotate normal --left-of HDMI-A-1
        elif [[ $SCREEN -eq 3 ]]; then
          ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-1 --primary --mode 1920x1080 --rotate normal --output HDMI-A-0 --mode 1920x1080 --rotate normal --left-of HDMI-A-1 --output DisplayPort-1 --mode 1280x1024 --rotate normal --right-of HDMI-A-1
        fi
      '';                                       # Settings for correct display configuration; This can also be done with setupCommands when X server start for smoother transition (if setup is static)
                                                # Another option to research in future is arandr
      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
      '';                                       # Used so computer don't goes to sleep

      resolutions = [
        { x = 1920; y = 1080; }
        { x = 1600; y = 900; }
        { x = 3840; y = 2160; }
      ];
    };
  };
}
