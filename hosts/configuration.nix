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

{ config, lib, pkgs, inputs, ... }:

{
  imports =                                 # Import window or display manager.
    [
      ../modules/desktop/bspwm/bspwm.nix
    ];

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
    keyMap = "azerty";
  };

  sound = {                                 # Sound settings
    enable = true;
    mediaKeys.enable = true;
  };

  hardware.pulseaudio = {                   # Hardware audio
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
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

    flatpak.enable = true;                  # (apparently not needed) flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    #                                       # download flatpak file from website
    # installed                             # sudo flatpak install <path>
    # - bottles                             # reboot
    #                                       # sudo flatpak uninstall --delete-data <app-id> (> flatpak list --app)
  };                                        # flatpak uninstall --unused

  xdg.portal = {                            # Required for flatpak
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  fonts.fonts = with pkgs; [                # Fonts
    source-code-pro
    font-awesome
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  users.users.matthias = {                  # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "plex" ];
    shell = pkgs.zsh;                       # Default shell
  };
 
  security = {                              # User does not need to give password when using sudo.
    sudo.wheelNeedsPassword = false;
  };

  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.

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

  programs = {                              # Shell. Weirdly need to be enable here to add user to lightdm by default.
    zsh.enable = true;
  };  
 
  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [           # Default packages install system-wide
      #vim
      git
      killall
      usbutils
      pciutils
      wget
      xterm
    ];
  };

  system = {                              # NixOS settings
    autoUpgrade = {                       # Allow auto update
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.05";
  };
}

