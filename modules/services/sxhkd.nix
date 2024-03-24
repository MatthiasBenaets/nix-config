#
#  Hotkey Daemon
#

{ config, lib, vars, ... }:

{
  config = lib.mkIf (config.x11wm.enable) {
    home-manager.users.${vars.user} = {
      services = {
        sxhkd = {
          enable = true;
          keybindings = {
            # Apps
            "super + Return" = "${vars.terminal}";
            "super + space" = "rofi -show drun -show-icons";
            "super + e" = "pcmanfm";
            "Print" = "flameshot gui";

            # Bspwm
            "super + {q,k}" = "bspc node -{c,k}";
            "super + Escape" = "bspc quit";
            "super + r" = "bspc wm -r";

            # Super - Nodes
            "super + {_,shift +}{Left,Right,Up,Down}" = "bspc node -{f,s} {west,east,north,south}";
            "super + m" = "bspc desktop -l next";
            "super + {t,h,f}" = "bspc node -t '~{tiled,floating,fullscreen}'";
            "super + g" = "bspc node -s biggest.window";

            # Alt - Move workspaces
            "alt + {Left,Right}" = "bspc desktop -f {prev,next}.local";
            "alt + {_,shift +}{1-9,0}" = "bspc {desktop -f,node -d} '{1-9,10}'";
            "alt + shift + {Left,Right}" = "bspc node -d {prev,next}.local --follow";

            # Control - Resize
            "control + {Left,Down,Up,Right}" = ''
              bspc node -z {left -20 0 || bspc node -z right -20 0, \
                            bottom 0 20 || bspc node -z top 0 20,\
                            top 0 -20 || bspc node -z bottom 0 -20,\
                            right 20 0 || bspc node -z left 20 0}
            '';

            # XF86 Keys
            "XF86AudioMute" = "pactl list sinks | grep -q Mute:.no && pactl set-sink-mute 0 1 || pactl set-sink-mute 0 0";
            "XF86AudioRaiseVolume" = "pactl -- set-sink-volume 0 +10%";
            "XF86AudioLowerVolume" = "pactl -- set-sink-volume 0 -10%";
            "XF86AudioMicMute" = "pactl set-source-mute 1 toggle";
            "XF86MonBrightnessDown" = "light -U  5";
            "XF86MonBrightnessUp" = "light -A 5";
          };
        };
      };
    };
  };
}
