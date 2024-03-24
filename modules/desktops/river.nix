#
#  River configuration
#  Enable with "river.enable = true;"
#

{ config, lib, pkgs, vars, host, ... }:

with lib;
with host;
{
  options = {
    river = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (config.river.enable) {
    wlwm.enable = true;

    environment = {
      loginShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec river
        fi
      '';

      variables = {
        # LIBCL_ALWAYS_SOFTWARE = "1"; # Needed for VM
        # WLR_NO_HARDWARE_CURSORS = "1";
      };
      systemPackages = with pkgs; [
        river # Window Manager
        wev # Event Viewer
        wl-clipboard # Clipboard
        wlr-randr # Monitor Settings
        xdg-desktop-portal-wlr # Wayland portal
        xwayland # X for Wayland
      ];
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };

    home-manager.users.${vars.user} =
      let
        monitor =
          if hostName == "h310m" then
            "riverctl spawn ${pkgs.wlr-randr}/bin/wlr-randr --output ${secondMonitor} --mode 1920x1080@60 --pos 0,0 --output ${mainMonitor} --mode 1920x1080@60 --pos 1920,0"
          else if hostName == "vm" || hostName == "probook" then
            "riverctl spawn ${pkgs.wlr-randr}/bin/wlr-randr --output ${mainMonitor} --mode 1920x1080@60 --pos 0,0"
          else false;
      in
      {
        home.file = {
          ".config/river/init" = {
            executable = true;
            text = ''
              #!/bin/sh

              riverctl spawn systemctl --user import-environment # Fix GTK Load

              # Monitor
              ${monitor}
              riverctl spawn ${pkgs.waybar}/bin/waybar

              riverctl map normal Super+Shift E exit
              riverctl map normal Super Q close

              riverctl map normal Super Return spawn ${vars.terminal}

              # Focus Layout Stack
              riverctl map normal Super J focus-view next
              riverctl map normal Super K focus-view previous

              # Swap
              riverctl map normal Super+Shift J swap next
              riverctl map normal Super+Shift K swap previous

              # Focus Output
              riverctl map normal Super Period focus-output next
              riverctl map normal Super Comma focus-output previous

              # Send Focus Output
              riverctl map normal Super+Shift Period send-to-output next
              riverctl map normal Super+Shift Comma send-to-output previous

              riverctl map normal Super+Shift Return zoom

              riverctl map normal Super H send-layout-cmd rivertile "main-ratio -0.05"
              riverctl map normal Super L send-layout-cmd rivertile "main-ratio +0.05"
              riverctl map-pointer normal Super BTN_RIGHT resize-view

              riverctl map normal Super+Shift H send-layout-cmd rivertile "main-count +1"
              riverctl map normal Super+Shift L send-layout-cmd rivertile "main-count -1"

              # Move View
              riverctl map normal Super+Alt H move left 100
              riverctl map normal Super+Alt J move down 100
              riverctl map normal Super+Alt K move up 100
              riverctl map normal Super+Alt L move right 100
              riverctl map-pointer normal Super BTN_LEFT move-view

              # Snap Views
              riverctl map normal Super+Alt+Control H snap left
              riverctl map normal Super+Alt+Control J snap down
              riverctl map normal Super+Alt+Control K snap up
              riverctl map normal Super+Alt+Control L snap right

              # Resize View
              riverctl map normal Super+Alt+Shift H resize horizontal -100
              riverctl map normal Super+Alt+Shift J resize vertical 100
              riverctl map normal Super+Alt+Shift K resize vertical -100
              riverctl map normal Super+Alt+Shift L resize horizontal 100

              for i in $(seq 1 9)
              do
                  tags=$((1 << ($i - 1)))
                  riverctl map normal Super $i set-focused-tags $tags # Focus Tag
                  riverctl map normal Super+Shift $i set-view-tags $tags # Tag Focus with Tag
                  riverctl map normal Super+Control $i toggle-focused-tags $tags # Toggle Focus of Tag
                  riverctl map normal Super+Shift+Control $i toggle-view-tags $tags # Toggle Tag of Focused View
              done

              all_tags=$(((1 << 32) - 1))
              riverctl map normal Super 0 set-focused-tags $all_tags # Focus All Tags
              riverctl map normal Super+Shift 0 set-view-tags $all_tags # Tag Focused View with All Tags

              riverctl map normal Super Space toggle-float

              riverctl map normal Super F toggle-fullscreen

              # Layout Orientation
              riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"
              riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
              riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
              riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"

              riverctl declare-mode passthrough # Declare Passthrough Mode
              riverctl map normal Super F11 enter-mode passthrough # Enter Passthrough Mode
              riverctl map passthrough Super F11 enter-mode normal # Enter Normal Mode

              for mode in normal locked # Media Keys
              do
                  # Eject Optical Drive
                  riverctl map $mode None XF86Eject spawn 'eject -T'

                  # Pulse Audio Volume
                  riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'
                  riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
                  riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'

                  # MPRIS Music Player
                  riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
                  riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
                  riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
                  riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

                  # Brightness
                  riverctl map $mode None XF86MonBrightnessUp   spawn 'light -A 5'
                  riverctl map $mode None XF86MonBrightnessDown spawn 'light -U 5'
              done

              # Background and Color
              riverctl background-color 0x002b36
              riverctl border-color-focused 0x93a1a1
              riverctl border-color-unfocused 0x586e75

              # Keyboard Repeat Rate
              riverctl set-repeat 50 300

              # Floating
              riverctl float-filter-add app-id float
              riverctl float-filter-add title "popup title with spaces"

              # Client Sided Decoration
              riverctl csd-filter-add app-id "gedit"

              # Default Layout
              riverctl default-layout rivertile
              rivertile -view-padding 6 -outer-padding 6
            '';
          };
        };
      };
  };
}
