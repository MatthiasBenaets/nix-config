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
#   loader.efi.canTouchEfiVariables = true;

#   initrd.kernelModules = [ "amdgpu" ];				# Video drivers
    
    loader = {								# EFI Boot
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {								# Most of grub is set up for dual boot
        enable = true;
        version = 2;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true; 						  # Find all boot options
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
    xserver = {
      libinput = {							# Trackpad support & gestures
        enable = true;
        touchpad.naturalScrolling = true;				# The correct way of scrolling
      };
      videoDrivers = [							# Video settings 
        "ati"
        "amdgpu"
        "radeon"
      ];
      resolutions = [
        { x = 1600; y = 920; }
        { x = 1280; y = 720; }
      ];
    };
  };
}
