#
#  Bspwm Home manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ home.nix *
#

{ pkgs, ... }:

{
  xsession = {
    windowManager = {
      bspwm = {
        enable = true;
#        monitors = {                            # Multiple monitors
#          HDMI-A-1 = [ "1" "2" "3" "4" "5" ];
#          HDMI-A-0 = [ "6" "7" "8" "9" "0" ];
#        };
        rules = {                               # Specific rules for apps - use xprop 
          "Emacs" = {
            desktop = "^3";
            follow = true;
            state = "tiled";
          };
          ".blueman-manager-wrapped" ={
            state = "floating";
            center = true;
            sticky = true;
          };
          "Google-chrome" = {
            desktop = "^2";
            #focus = true;
            #manage = false;
          }; 
          "libreoffice" ={
            desktop = "^4";
          };
          "Pavucontrol" = {
            state = "floating";
            center = true;
            sticky = true;
          };
          "Pcmanfm" = {
            state = "floating";
          };
          "plexmediaplayer" = {
            desktop = "^5";
            state = "fullscreen";
          };
          "*:*:Picture in picture" = {
            state = "floating";
          };
        };
        extraConfig = ''
          feh --bg-scale $HOME/.config/wall     # Wallpaper

          #pgrep -x sxhkd > /dev/null || sxhkd &

          killall -q polybar &                  # Reboot polybar to correctly show workspaces

          while pgrep -u $UID -x polybar >/dev/null; do sleep 1;done 

          polybar main & #2>~/log &             # To lazy to figure out systemd service order
          
          if [[ $(xrandr -q | grep 'HDMI-A-0 connected') ]]; then   # If second monitor, also enable second polybar
            bspc monitor HDMI-A-0 -s HDMI-A-1
            bspc monitor HDMI-A-0 -d 6 7 8 9 0
            polybar sec &

            xset -dpms &                        # No sleep after 10 minutes idle
            xset s off &
          fi

          bspc monitor -d 1 2 3 4 5             # Workspace tag names (need to be the same as the polybar config to work)

          bspc config border_width      2
          bspc config window_gaps      12
          bspc config split_ratio     0.5
          
          bspc config focus_follows_pointer     true
          #bspc config borderless_monocle       true
          #bspc config gapless_monocle          true

          #bspc config normal_border_color  "#44475a"
          #bspc config focused_border_color "#bd93f9"

          #bspc rule -a vlc state=fullscreen
        '';
      };
    };
  };
}
