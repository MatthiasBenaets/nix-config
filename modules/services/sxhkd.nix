#
#  Hotkey Daemon
#

{ config, lib, pkgs, vars, ... }:

{
  config = lib.mkIf (config.x11wm.enable) {
    home-manager.users.${vars.user} = {
      services = {
        sxhkd = {
          enable = true;
          keybindings = {
            # Apps
            "super + Return" = "${vars.terminal}";                # Terminal
            "super + space" = "rofi -show drun -show-icons";      # Application Menu
            "super + e" = "pcmanfm";                              # File Browser
            "Print" = "flameshot gui";                            # Screenshots

            # Bspwm
            "super + {q,k}" = "bspc node -{c,k}";                 # Close or Kill
            "super + Escape" = "bspc quit";                       # Exit WM
            "super + r" = "bspc wm -r";                           # Reload WM

            # Super - Nodes
            "super + {_,shift +}{Left,Right,Up,Down}" = "bspc node -{f,s} {west,east,north,south}";  # Focus or move node in given direction
            "super + m" = "bspc desktop -l next";                 # Alternate between the tiled and monocle layout
            "super + {t,h,f}" = "bspc node -t '~{tiled,floating,fullscreen}'"; # Toggle between initial state and new state
            "super + g" = "bspc node -s biggest.window";          # Swap current node and the biggest window

            # Alt - Move workspaces
            "alt + {Left,Right}" = "bspc desktop -f {prev,next}.local"; # Focus the next/previous desktop in the current monitor
            "alt + {_,shift +}{1-9,0}" = "bspc {desktop -f,node -d} '{1-9,10}'"; # Focus or send to the given desktop
            "alt + shift + {Left,Right}" = "bspc node -d {prev,next}.local --follow"; # Send and follow to previous or next desktop

            # Control - Resize
            "control + {Left,Down,Up,Right}" = ''
              bspc node -z {left -20 0 || bspc node -z right -20 0, \
                            bottom 0 20 || bspc node -z top 0 20,\
                            top 0 -20 || bspc node -z bottom 0 -20,\
                            right 20 0 || bspc node -z left 20 0}
            '';                                                   # Expand and shrink

            # XF86 Keys
            "XF86AudioMute" = "pactl list sinks | grep -q Mute:.no && pactl set-sink-mute 0 1 || pactl set-sink-mute 0 0";  # Toggle mute audio
            "XF86AudioRaiseVolume" = "pactl -- set-sink-volume 0 +10%";   # Raise volume
            "XF86AudioLowerVolume" = "pactl -- set-sink-volume 0 -10%";   # Lower volume
            "XF86AudioMicMute" = "pactl set-source-mute 1 toggle";        # Toggle mute mic audio
            "XF86MonBrightnessDown" = "light -U  5";              # Brightness down
            "XF86MonBrightnessUp" = "light -A 5";                 # Brightness up
          };
        };
      };
    };
  };
}
