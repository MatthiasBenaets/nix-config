{ config, lib, pkgs, system, ... }:
let
  # exec = with host; if hostName == "work" then "exec nvidia-offload Hyprland" else "exec Hyprland"; # Starting Hyprland with nvidia (bit laggy so disabling)
  exec = "exec Hyprland";
in
{

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        ${exec}
      fi
    '';                                   # Will automatically open Hyprland when logged into tty1

    variables = {
      #WLR_NO_HARDWARE_CURSORS="1";         # Possible variables needed in vm
      #WLR_RENDERER_ALLOW_SOFTWARE="1";
      XDG_CURRENT_DESKTOP="Hyprland";
      XDG_SESSION_TYPE="wayland";
      XDG_SESSION_DESKTOP="Hyprland";
    };
      sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      GDK_BACKEND = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
    systemPackages = with pkgs; [
      networkmanagerapplet
      blueman
      grim
      mpvpaper
      slurp
      swappy
      wl-clipboard
      wlr-randr
      swaybg
      wpaperd
      dunst
      rofi
      cinnamon.nemo
      colloid-gtk-theme
      colloid-icon-theme
    ];
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      enableNvidiaPatches = true;
    };
  };

  xdg.portal = {                                  # Required for flatpak with window managers and for file browsing
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

}
