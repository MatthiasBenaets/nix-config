#
# Gnome configuration
#

{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  services = {
    xserver = {
      enable = true;

      layout = "us";                              # Keyboard layout & €-sign
      xkbOptions = "eurosign:e";
      libinput.enable = true;
      modules = [ pkgs.xf86_input_wacom ];        # Both needed for wacom tablet usage
      wacom.enable = true;

      displayManager.gdm.enable = true;           # Display Manager
      desktopManager.gnome.enable = true;         # Window Manager
    };
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
  };

  #programs.zsh.enable = true;                     # Weirdly needs to be added to have default user on lightdm

  hardware.pulseaudio.enable = false;

  environment = {
    systemPackages = with pkgs; [                 # Packages installed
      gnome.gnome-tweaks
      gnome.adwaita-icon-theme
      #gnomeExtensions.appindicator
      #gnomeExtensions.pop-shell
    ];
    gnome.excludePackages = (with pkgs; [         # Gnome ignored packages
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gedit
      epiphany
      geary
      gnome-characters
      tali
      iagno
      hitori
      atomix
      yelp
      gnome-contacts
      gnome-initial-setup
    ]);
  };
}
