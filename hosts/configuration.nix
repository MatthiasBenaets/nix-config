#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ bspwm.nix
#             

{ config, lib, pkgs, inputs, ... }:

{
  imports =								# Import window or display manager.
    [
      ../modules/desktop/bspwm.nix
    ];

  networking.useDHCP = false; 						# Deprecated but needed in config.

  time.timeZone = "Europe/Brussels";					# Time zone and internationalisation
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "azerty";
  };

  sound = {								# Sound settings
    enable = true;
    mediaKeys.enable = true;
  };

  hardware.pulseaudio = {						# Hardware audio
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

# hardware.sane = {							# Used for scanning
#   enable = true,
#   extraBackends = [ pkgs.<<canon>> ];
# };

  services = {
#   printing = {							# Printing service
#     enable = true;
#     drivers = [ pkgs.<<canon>> ];
#   };
#
#   openssh = {								# SSH
#     enable = true;
#     allowSFTP = true;
#   };

#   sshd.enable = true;
  };

# services.xserver.libinput.enable = true; 				# Trackpad. Maybe better to enable in host profile

  fonts.fonts = with pkgs; [						# Fonts
    source-code-pro
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  users.users.matthias = {						# System User
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "lp" "scanner"];
    shell = pkgs.zsh;							  # Default shell
  };
 
  programs = {								# Shell. Weirdly need to be enable here to add user to lightdm by default.
    zsh.enable = true;
  };  
 
  security = {								# User does not need to give password when using sudo.
    sudo.wheelNeedsPassword = false;
  };

  nixpkgs.config.allowUnfree = true;					# Allow proprietary software.

  nix = {								# Nix Package Manager settings
    autoOptimiseStore = true;						  # Optimize symlinks
    gc = {								  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;						  # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  environment.systemPackages = with pkgs; [				# Default packages install system-wide
    vim
    git
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {								# NixOS settings
    autoUpgrade = {							  # Allow auto update
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.05";
  };
}

