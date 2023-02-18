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
        "com.obsproject.Studio.desktop"
        "plexmediaplayer.desktop"
        "smartcode-stremio.desktop"
        "discord.desktop"
        "steam.desktop"
        "retroarch.desktop"
        "com.parsecgaming.parsec.desktop"
        "org.remmina.Remmina.desktop"
        "virt-manager.desktop"
        # "blueman-manager.desktop"
        # "pavucontrol.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "trayIconsReloaded@selfmade.pl"
        "blur-my-shell@aunetx"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "dash-to-panel@jderose9.github.com"
        "just-perfection-desktop@just-perfection"
        "caffeine@patapon.info"
        "clipboard-indicator@tudmotu.com"
        "horizontal-workspace-indicator@tty2.io"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "battery-indicator@jgotti.org"
        "gsconnect@andyholmes.github.io"
        "pip-on-top@rafostar.github.com"
        "forge@jmmaranan.com"
        # "dash-to-dock@micxgx.gmail.com"             # Dash to panel alternative
        # "fullscreen-avoider@noobsai.github.com"     # Incompatible with dash-to-panel
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
      #gtk-theme = "Adwaita-dark";
    };
    # "org/gnome/desktop/session" = {                 # Doesn't seem to work
    #   idle-delay = "uint32 900";
    # };
    "org/gnome/desktop/privacy" = {
      report-technical-problems = "false";
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      action-right-click-titlebar = "toggle-maximize";
      action-middle-click-titlebar = "minimize";
      resize-with-right-button = true;
      mouse-button-modifier = "<Super>";
      button-layout = ":minimize,close";
    };
    "org/gnome/desktop/wm/keybindings" = {
      # maximize = ["<Super>Up"];                     # For floating
      # unmaximize = ["<Super>Down"];
      maximize = ["@as []"];                          # For tilers
      unmaximize = ["@as []"];
      switch-to-workspace-left = ["<Alt>Left"];
      switch-to-workspace-right = ["<Alt>Right"];
      switch-to-workspace-1 = ["<Alt>1"];
      switch-to-workspace-2 = ["<Alt>2"];
      switch-to-workspace-3 = ["<Alt>3"];
      switch-to-workspace-4 = ["<Alt>4"];
      switch-to-workspace-5 = ["<Alt>5"];
      move-to-workspace-left = ["<Shift><Alt>Left"];
      move-to-workspace-right = ["<Shift><Alt>Right"];
      move-to-workspace-1 = ["<Shift><Alt>1"];
      move-to-workspace-2 = ["<Shift><Alt>2"];
      move-to-workspace-3 = ["<Shift><Alt>3"];
      move-to-workspace-4 = ["<Shift><Alt>4"];
      move-to-workspace-5 = ["<Shift><Alt>5"];
      move-to-monitor-left = ["<Super><Alt>Left"];
      move-to-monitor-right = ["<Super><Alt>Right"];
      close = ["<Super>q" "<Alt>F4"];
      toggle-fullscreen = ["<Super>f"];
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
      center-new-windows = true;
      edge-tiling = false;                            # Disabled when tiling
    };
    "org/gnome/mutter/keybindings" = {
      #toggle-tiled-left = ["<Super>Left"];           # For floating
      #toggle-tiled-right = ["<Super>Right"];
      toggle-tiled-left = ["@as []"];                 # For tilers
      toggle-tiled-right = ["@as []"];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-interactive-ac-type = "nothing";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "alacritty";
      name = "open-terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>t";
      command = "emacs";
      name = "open-editor";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>e";
      command = "nautilus";
      name = "open-file-browser";
    };

    "org/gnome/shell/extension/dash-to-panel" = {     # Possibly need to set this manually
      panel-position = ''{"0":"TOP","1":"Top"}'';
      panel-sizes = ''{"0":24,"1":24}'';
      panel-element-positions-monitors-sync = true;
      appicon-margin = 0;
      appicon-padding = 4;
      dot-position = "TOP";
      dot-style-focused = "SOLID";
      dot-style-unfocused = "DOTS";
      animate-appicon-hover = true;
      animate-appicon-hover-animation-travel = "{'SIMPLE': 0.14999999999999999, 'RIPPLE': 0.40000000000000002, 'PLANK': 0.0}";
      isolate-monitors = true;
    };
    "org/gnome/shell/extensions/just-perfection" = {
      theme = true;
      activities-button = false;
      app-menu = false;
      clock-menu-position = 1;
      clock-menu-position-offset = 7;
    };
    "org/gnome/shell/extensions/caffeine" = {
      enable-fullscreen = true;
      restore-state = true;
      show-indicator = true;
      show-notification = false;
    };
    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.9;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      customize = true;
      sigma = 0;
    };
    "org/gnome/shell/extensions/blur-my-shell/overview" = { # Temporary = D2D Bug
      customize = true;
      sigma = 0;
    };
    "org/gnome/shell/extensions/horizontal-workspace-indicator" = {
      widget-position = "left";
      widget-orientation = "horizontal";
      icons-style = "circles";
    };
    "org/gnome/shell/extensions/bluetooth-quick-connect" = {
      show-battery-icon-on = true;
      show-battery-value-on = true;
    };
    "org/gnome/shell/extensions/pip-on-top" = {
      stick = true;
    };
    "org/gnome/shell/extensions/forge" = {
      window-gap-size = 8;
      dnd-center-layout = "stacked";
    };
    "org/gnome/shell/extensions/forge/keybindings" = {      # Set active colors manually
      focus-border-toggle = true;
      float-always-on-top-enabled = true;
      window-focus-up = ["<Super>Up"];
      window-focus-down = ["<Super>Down"];
      window-focus-left = ["<Super>Left"];
      window-focus-right = ["<Super>Right"];
      # window-swap-up = ["<Shift><Super>Up"];
      # window-swap-down = ["<Shift><Super>Down"];
      # window-swap-left = ["<Shift><Super>Left"];
      # window-swap-right = ["<Shift><Super>Right"];
      window-move-up = ["<Shift><Super>Up"];
      window-move-down = ["<Shift><Super>Down"];
      window-move-left = ["<Shift><Super>Left"];
      window-move-right = ["<Shift><Super>Right"];
      window-swap-last-active = ["@as []"];
      window-toggle-float = ["<Shift><Super>f"];
    };
    # "org/gnome/shell/extensions/dash-to-dock" = {   # If dock if preferred
    #   multi-monitor = true;
    #   dock-fixed = true;
    #   dash-max-icon-size = 16;
    #   custom-theme-shrink = true;
    #   transparency-mode = "FIXED";
    #   background-opacity = 0.0;
    #   show-apps-at-top = true;
    #   show-trash = true;
    #   hot-keys = false;
    #   click-action = "previews";
    #   scroll-action = "cycle-windows";
    # };
  };

  home.packages = with pkgs; [
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.blur-my-shell
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.dash-to-panel
    gnomeExtensions.battery-indicator-upower
    gnomeExtensions.just-perfection
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.workspace-indicator-2
    gnomeExtensions.bluetooth-quick-connect
    gnomeExtensions.gsconnect                         # kdeconnect enabled in default.nix
    gnomeExtensions.pip-on-top
    gnomeExtensions.pop-shell
    gnomeExtensions.forge
    # gnomeExtensions.fullscreen-avoider
    # gnomeExtensions.dash-to-dock
  ];
}
