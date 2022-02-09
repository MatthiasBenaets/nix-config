#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   └─ ./hosts
#       └─ ./laptop
#            ├─ default.nix *
#            └─ hardware-configuration.nix       
#

{ config, pkgs, ... }:

{
  imports =  [								# For now, if applying to other system, swap files
    ./hardware-configuration.nix					  # Current system hardware config @ /etc/nixos/hardware-configuration.nix
  ];

  boot = {								# Boot options
    kernelPackages = pkgs.linuxPackages_latest;

#   loader.systemd-boot.enable = true;					# For UEFI-boot use these settings.
    loader.efi.canTouchEfiVariables = true;

    initrd.kernelModules = [ "amdgpu" ];				# Video drivers
    
    loader = {								# For legacy boot:
      grub = {
        enable = true;
        version = 2;
        device = [ "nodev" ];						  # Name of harddrive
        efiInstallAsRemovable = true;
        efiSupport = true;
        useOSProber = true;
      };
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    interfaces = {
      enp0s25.useDHCP = true;						  # Change to correct network driver.
      wlo1.useDHCP = true;
    };
  };

  hardware.bluetooth = {                                                # Bluetooth
    enable = true;
    hsphfpd.enable = true;                                                # HSP & HFP daemon
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

# fileSystems."/data" = {
#   device = "/dev/nvme0n1p3";
#   fsType = "ext4";
# };

  services = {
    tlp.enable = true;							# TLP and auto-cpufreq for power management
    auto-cpufreq.enable = true;
    blueman.enable = true;
    dbus.packages = with pkgs; [
      polybar								# systemctl status --user $*.service
      dunst
    ];
    xserver = {							        # In case, multi monitor support
      #videoDrivers = [ "amdgpu" ];					# Keeping this here for the future.

#     xrandrHeads = [
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
#     resolutions = [
#       { x = 2048; y = 1152; }
#       { x = 1920; y = 1080; }
#       { x = 2560; y = 1440; }
#       { x = 3072; y = 1728; }
#       { x = 3840; y = 2160; }
#     ];
    };
  };
  
  programs = {
    nm-applet.enable = true;
  };
}
