#
# Gnome Home-Manager Configuration
#
# Dconf settings can be found by running "$ dconf watch /"
#

{ config, lib, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Settings.desktop"
        "Alacritty.desktop"
        "firefox.desktop"
        "emacs.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        # "pop-shell@system76.com"
        "trayIconsReloaded@selfmade.pl"
        "blur-my-shell@aunetx"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "fullscreen-avoider@noobsai.github.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/desktop/session" = {
      idle-delay = "uint32 900";
    };
    "org/gnome/desktop/privacy" = {
      report-technical-problems = "false";
    };
    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
      edge-tiling = true;
    };
    # "org/gnome/mutter/keybindings" = {
    #   toggle-tiled-left = "@as []";
    #   toggle-tiled-right = "@as []";
    # };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-interactive-ac-type = "nothing";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };
    # "org/gnome/desktop/wm/keybindings" = {          # For some reason doesn't seem to work
    #   maximize = "@as []";
    #   unmaximize = "@as []";
    #   move-to-workspace-1 = "<Shift><Super>1";
    #   move-to-workspace-2 = "<Shift><Super>2";
    #   move-to-workspace-3 = "<Shift><Super>3";
    #   move-to-workspace-4 = "<Shift><Super>4";
    #   close = "<Super>q";
    #   toggle-fullscreen = "<Super>f";
    # };

    "org/gnome/shell/extensions/dash-to-dock" = {
      multi-monitor = true;
      dock-fixed = true;
      dash-max-icon-size = 16;
      custom-theme-shrink = true;
      transparency-mode = "FIXED";
      background-opacity = 0.0;
      show-apps-at-top = true;
      show-trash = false;
    };
    # "org/gnome/shell/extensions/pop-shell" = {
    #   tile-by-default = true;
    #   gap-outer = "uint32 2";
    # };
  };

  home.packages = with pkgs; [
    # gnomeExtensions.pop-shell
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.blur-my-shell
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.fullscreen-avoider
    gnomeExtensions.dash-to-dock
  ];
}
