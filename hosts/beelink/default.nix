#
#  Specific system configuration settings for beelink
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./beelink
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ hyprland.nix
#           └─ ./virtualisation
#               └─ default.nix
#
#  NOTE: Dual booted with windows 11. Disable fast-boot in power plan and bios and turn off hibernate to get wifi and bluetooth working. This only works once but on reboot is borked again. So using the old school BLT dongle.
#

{ pkgs, ... }:

{
  imports = [
              ./hardware-configuration.nix
              ../../modules/programs/games.nix
            ] ++
            ( import ../../modules/hardware/beelink) ++
            ( import ../../modules/desktops/virtualisation);

  boot = {                                      # Boot Options
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
      efi = {
        canTouchEfiVariables = true;
      };
      timeout = 5;
    };
  };

  hardware = {
    opengl = {                                  # Hardware Accelerated Video
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    sane = {                                    # Scanning
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  hyprland.enable = true;                       # Window Manager

  environment = {
    systemPackages = with pkgs; [               # System-Wide Packages
      discord               # Messaging
      gimp                  # Image Editor
      gmtp                  # Mount GoPro
      jellyfin-media-player # Media Player
      moonlight-qt          # Remote Streaming
      obs-studio            # Live Streaming
      plex-media-player     # Media Player
      rclone                # Gdrive ($ rclone config | rclone mount --daemon gdrive:<path> <host/path>)
      simple-scan           # Scanning
    ];
  };

  flatpak = {                                   # Flatpak Packages (see module options)
    extraPackages = [
      "com.github.tchx84.Flatseal"
      "com.ultimaker.cura"
      "com.stremio.Stremio"
    ];
  };

  nixpkgs.overlays = [                          # Overlay pulls latest version of Discord
    (final: prev: {
      discord = prev.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "0pml1x6pzmdp6h19257by1x5b25smi2y60l1z40mi58aimdp59ss";
        };}
      );
    })
  ];
}
