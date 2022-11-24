#
#  Bspwm Home manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ home.nix *
#

{ config, lib, pkgs, ... }:

{
  imports = [
    ../../services/flameshot.nix
    ../../services/picom.nix
    ../../services/polybar.nix
    ../../services/sxhkd.nix
  ];
  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager = {
      bspwm = {
        enable = true;
#        monitors = {                            # Multiple monitors
#          HDMI-A-1 = [ "1" "2" "3" "4" "5" ];
#          HDMI-A-0 = [ "6" "7" "8" "9" "0" ];
#        };
        rules = {                               # Specific rules for apps - use xprop
          "Emacs" = {
            desktop = "3";
            follow = true;
            state = "tiled";
          };
          ".blueman-manager-wrapped" = {
            state = "floating";
            sticky = true;
          };
          "libreoffice" = {
            desktop = "3";
            follow = true;
          };
          "Lutris" = {
            desktop = "5";
            follow = true;
          };
          "Pavucontrol" = {
            state = "floating";
            sticky = true;
          };
          "Pcmanfm" = {
            state = "floating";
          };
          "plexmediaplayer" = {
            desktop = "4";
            follow= true;
            state = "fullscreen";
          };
          "*:*:Picture in picture" = {  #Google Chrome PIP
            state = "floating";
            sticky = true;
          };
          "*:*:Picture-in-Picture" = {  #Firefox PIP
            state = "floating";
            sticky = true;
          };
          "Steam" = {
            desktop = "5";
            #follow = true;
          };
        };
        extraConfig = ''
          bspc monitor -d 1 2 3 4 5               # Workspace tag names (need to be the same as the polybar config to work)

          bspc config border_width      3
          bspc config window_gaps      12
          bspc config split_ratio     0.5

          bspc config click_to_focus            true
          bspc config focus_follows_pointer     false
          bspc config borderless_monocle        false
          bspc config gapless_monocle           false

          #bspc config normal_border_color  "#000000"
          #bspc config focused_border_color "#ffffff"

          #pgrep -x sxhkd > /dev/null || sxhkd &  # Not needed on NixOS

          feh --bg-tile $HOME/.config/wall        # Wallpaper

          killall -q polybar &                    # Reboot polybar to correctly show workspaces
          while pgrep -u $UID -x polybar >/dev/null; do sleep 1;done 

          polybar main & #2>~/log &               # To lazy to figure out systemd service order

          #Setting for desktop:
          #if [[ $(xrandr -q | grep 'DisplayPort-1 connected') ]]; then   # If second monitor, also enable second polybar
            #bspc monitor DisplayPort-1 -s HDMI-A-1
            #bspc monitor DisplayPort-1 -d 6 7 8 9 10
            #bspc wm -O HDMI-A-1 DisplayPort-1
            bspc monitor DP1 -d 6 7 8 9 10
            bspc wm -O HDMI3 DP1
            polybar sec &
          #fi
        '';
      };
    };
  };
}
