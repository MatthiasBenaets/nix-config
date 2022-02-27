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
    networkmanager.enable = true;
    interfaces = {
      enp3s0 = {                                # Change to correct network driver
        # useDHCP = true;                       # Disabled because fixed ip
        ipv4.addresses = [ {                    # Ip settings: *.0.50 for main machine
          address = "192.168.0.50";
          prefixLength = 24;
        } ];
      };
      wlp2s0.useDHCP = true;                    # Wireless card
    };
    defaultGateway = "192.168.0.1";
    nameservers = [ "1.1.1.1" ];                # Cloudflare
  };

  environment = {
    systemPackages = with pkgs; [
      discord
      plex
      steam
    ];
  };

  programs = {
    steam.enable = true;
  };
  
  nixpkgs.overlays = [
     (self: super: {
       discord = super.discord.overrideAttrs (
         _: { src = builtins.fetchTarball {
           url = "https://discord.com/api/download?platform=linux&format=tar.gz"; 
           sha256 = "0hdgif8jpp5pz2c8lxas88ix7mywghdf9c9fn95n0dwf8g1c1xbb";
         };}
       );
     })
  ];

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
    xserver = {                                 # In case, multi monitor support
      videoDrivers = [                          # Video Settings
        "amdgpu"
      ];

      displayManager.setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-1 --primary --mode 1920x1080 --rotate normal --output HDMI-A-0 --mode 1920x1080 --rotate normal --left-of HDMI-A-1
      '';

      resolutions = [
        { x = 1920; y = 1080; }
        { x = 1600; y = 900; }
        { x = 3840; y = 2160; }
      ];
    };
  };
}
