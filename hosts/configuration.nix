# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ../modules/desktop/bspwm.nix
    ];

  networking.useDHCP = false; #deprecated but needed

  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "azerty";
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  hardware.pulseaudio = {
    enable = true;
#   extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

# hardware.sane = {
#   enable = true,
#   extraBackends = [ pkgs.<<canon> ];
# };

  services = {
#   printing = {
#     enable = true;
#     drivers = [ pkgs.<<canon>> ];
#   };
#
#   openssh = {
#     enable = true;
#     allowSFTP = true;
#   };

#   sshd.enable = true;
  };

# services.xserver.libinput.enable = true; #trackpad, better add in hosts default

  fonts.fonts = with pkgs; [
    source-code-pro
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  programs.zsh.enable = true; 

  users.users.matthias = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "lp" "scanner"];
    shell = pkgs.zsh;
  };
  
  security = {
    sudo.wheelNeedsPassword = false;
  };

  nixpkgs.config.allowUnfree = true;

  #nix = {
  #  autoOptimiseStore = true;
  #  gc = {
  #    automatic = true;
  #    dates = "weekly";
  #    options = "--delete-older-than 7d";
  #  };
  #  package = pkgs.nixFlakes;
   # registery.nixpkgs.flake = inputs.nixpkgs;
  #  extraOptions = ''
  #    experimental-features = nix-command flakes
  #    keep-outputs          = true
  #    keep-derivations      = true
  #  '';
  #};

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
  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.05";
  };
}

