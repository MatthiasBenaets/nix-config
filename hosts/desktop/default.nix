#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   └─ ./hosts
#       └─ ./desktop
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

#    loader.systemd-boot.enable = true;					# For UEFI-boot use these settings.
#    loader.efi.canTouchEfiVariables = true;

#    initrd.kernelModules = [ "amdgpu" ];				# Video drivers
    
    loader = {								# For legacy boot:
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";						  # Name of harddrive
      };
    };
  };

  networking = {
    hostName = "nixos";
    interfaces = {
      enp0s3.useDHCP = true;						  # Change to correct network driver.
    };
  };

# hardware.bluetooth = {                                                # Bluetooth
#   enable = true;
#   hsphfpd.enable = true;                                                # HSP & HFP daemon
#   settings = {
#     General = {
#       Enable = "Source,Sink,Media,Socket";
#     };
#   };
# };

  services.dbus.packages = with pkgs;[					# No DisplayManager so enable services here.
    polybar
    dunst
  ];

  services =
    xserver = {								# In case, multi monitor support
#     blueman.enable = true;
      dbus.packages = with pkgs; [					# Systemctl status --user *.service
        polybar
        dunst
      ];
#     videoDrivers = [ 							# Video Settings
#       "amdgpu"
#       "radeon"
#     ];

#   xrandrHeads = [							# Dual screen setting placeholder
#     { output = "HDMI-A-0";
#       primary = true;
#       monitorConfig = ''
#         Modeline "3840x2160_30.00"  338.75  3840 4080 4488 5136  2160 2163 2168 2200 -hsync +vsync
#         Option "PreferredMode" "3840x2160_30.00"
#         Option "Position" "0 0"
#       '';
#     }
#     { output = "eDP";
#       primary = false;
#       monitorConfig = ''
#         Option "PreferredMode" "1920x1080"
#         Option "Position" "0 0"
#       '';
#     }
#   ];
#
    resolutions = [
      { x = 1920; y = 1080; }
      { x = 1600; y = 900; }
      { x = 3840; y = 2160; }
    ];
  };
}
