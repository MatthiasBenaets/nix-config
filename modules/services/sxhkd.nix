#
# Keyboard shortcuts
#

{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (config.xsession.enable) {                  # Only evaluate code if using X11 
    services = {
      sxhkd = {
        enable = true;
        keybindings = {
          # Apps
          "super + Return" = "alacritty";                       # Open Terminal
          "super + space" = "rofi -show drun";                  # Open Rofi (custom theme " -theme theme.rasi")
          "super + e" = "pcmanfm";                              # File Manager

          "Print" = "flameshot gui";                            # Start flameshot gui

          # Bspwm
          "super + {q,k}" = "bspc node -{c,k}";                 # Close or Kill
          "super + Escape" = "bspc quit";                       # Exit WM
          "super + r" = "bspc wm -r";                           # Reload WM

          # Super - Nodes
          "super + {_,shift +}{Left,Right,Up,Down}" = "bspc node -{f,s} {west,east,north,south}";  # Focus or move node in given direction
          "super + m" = "bspc desktop -l next";                 # Alternate between the tiled and monocle layout
          "super + {t,h,f}" = "bspc node -t '~{tiled,floating,fullscreen}'"; # Toggle between initial state and new state
            #"super + t" = "bspc node -t tiled";                   # Put node in tiled ( t is for tiled )
            #"super + h" = "bspc node -t floating";                # Put node in floating ( h is for hover )
            #"super + f" = "bspc node -t fullscreen";              # Toggle fullscreen ( f is for fullscreen )
          "super + g" = "bspc node -s biggest.window";          # Swap current node and the biggest window

          # Alt - Move workspaces
          "alt + {Left,Right}" = "bspc desktop -f {prev,next}.local"; # Focus the next/previous desktop in the current monitor
          "alt + {_,shift +}{1-9,0}" = "bspc {desktop -f,node -d} '{1-9,10}'";
          "alt + shift + {Left,Right}" = "bspc node -d {prev,next}.local --follow"; # Send and follow to previous or next desktop
            #"alt + {_,shift +}{ampersand,eacute,quotedbl,apostrophe,parenleft,section,egrave,exclam,ccedilla,agrave}" = "bspc {desktop -f,node -d} '{1-9,10}'"; # Focus or send to the given desktop for azerty


          # Control - Resize
          "control + {Left,Down,Up,Right}" = ''
            bspc node -z {left -20 0 || bspc node -z right -20 0, \
                          bottom 0 20 || bspc node -z top 0 20,\
                          top 0 -20 || bspc node -z bottom 0 -20,\
                          right 20 0 || bspc node -z left 20 0}
          '';                                                   # Expand and shrink
            #"control + {Left,Right,Up,Down}" = "bspc node -z {left -20 0,right 20 0,top 0 -20,bottom 0 20}";          # Expand window by moving one of its sides outwards
            #"control + shift + {Left,Right,Up,Down}" = "bspc node -z { right -20 0,left 20 0,bottom 0 -20,top 0 20}"; # Contract window by moving one of its sides inwards

          # XF86 Keys
          "XF86AudioMute" = "pactl list sinks | grep -q Mute:.no && pactl set-sink-mute 0 1 || pactl set-sink-mute 0 0";  # Toggle mute audio
          "XF86AudioRaiseVolume" = "pactl -- set-sink-volume 0 +10%";   # Raise volume
          "XF86AudioLowerVolume" = "pactl -- set-sink-volume 0 -10%";   # Lower volume
          "XF86AudioMicMute" = "pactl set-source-mute 1 toggle";        # Toggle mute mic audio
          "XF86MonBrightnessDown" = "light -U  5"; #"xrandr --output eDP-1 --brightness 0.3"; #"xbacklight -dec 10%";     # Brightness down
          "XF86MonBrightnessUp" = "light -A 5"; #"xrandr --output eDP-1 --brightness 1.0 "; #"xbacklight -inc 10%";       # Brightness up
        };
      };
    };
  };   
}
