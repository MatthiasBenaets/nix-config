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
#       monitors = {                            # Multiple monitors
#          eDP-1 = [ "1" "2" "3" "4" "5" ];
#       };
        rules = {                               # Specific rules for apps - use xprop 
          "Emacs" = {
            desktop = "^3";
            follow = true;
            state = "tiled";
          };
          "blueman-manager" ={
            state = "floating";
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
            sticky= true;
          };
          "Pcmanfm" = {
            state = "floating";
          };
          "plexmediaplayer" = {
            desktop = "^5";
            state = "fullscreen";
          };

        };
        extraConfig = ''
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

          #pgrep -x sxhkd > /dev/null || sxhkd &

          feh --bg-scale $HOME/.config/wall

          killall -q polybar &                  # Reboot polybar to correctly show workspaces
          sleep 0.5; polybar top & #2>~/log &   # To lazy to figure out systemd service order
        '';
      };
    };
  };
}
