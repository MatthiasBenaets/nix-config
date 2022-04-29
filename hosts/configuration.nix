#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ bspwm.nix
#             

{ config, lib, pkgs, inputs, user, ... }:

{
  imports =                                 # Import window or display manager.
    [
      ../modules/desktop/bspwm/bspwm.nix
    ];

  users.users.${user} = {                   # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "plex" ];
    shell = pkgs.zsh;                       # Default shell
  };
  security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.

  networking.useDHCP = false;               # Deprecated but needed in config.

  time.timeZone = "Europe/Brussels";        # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {                 # Extra locale settings that need to be overwritten
      LC_TIME = "nl_BE.UTF-8";
      LC_MONETARY = "nl_BE.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";	                    # or us/azerty/etc
  };

  fonts.fonts = with pkgs; [                # Fonts
    carlito
    vegur
    source-code-pro
    font-awesome                            # Icons
    corefonts                               # MS
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [           # Default packages install system-wide
      #vim
      #git
      killall
      nano
      pciutils
      usbutils
      wget
      xclip
      xterm
    ];
  };

  services = {
    xserver = {
      libinput = {                          # Needed for all input devices
        enable = true;
      };
    };
#   openssh = {                             # SSH
#     enable = true;
#     allowSFTP = true;
#   };
#   sshd.enable = true;
    flatpak.enable = true;                  # download flatpak file from website - sudo flatpak install <path> - reboot if not showing up
                                            # sudo flatpak uninstall --delete-data <app-id> (> flatpak list --app) - flatpak uninstall --unused
  };

  xdg.portal = {                            # Required for flatpak
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  nix = {                                   # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;               # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.

  system = {                                # NixOS settings
    autoUpgrade = {                         # Allow auto update
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.05";
  };
}

