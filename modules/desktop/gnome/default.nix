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

      displayManager = {                          # Display Manager
        gdm = {
          enable = true;
        };
      };
      desktopManager= {
        gnome = {                                 # Window Manager
          enable = true;
        };
      };
    };
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
  };

  programs.zsh.enable = true;                     # Weirdly needs to be added to have default user on lightdm

  hardware.pulseaudio.enable = false;

  environment = {
    systemPackages = with pkgs; [                 # Packages installed
      gnome.adwaita-icon-theme
      gnomeExtensions.appindicator
      gnomeExtensions.pop-shell
    ];
    gnome.excludePackages = (with pkgs; [         # Gnome ignored packages
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gedit
      epiphany
      geary
      evince
      tali
      iagno
      hitori
      atomix
    ]);
  };
}
