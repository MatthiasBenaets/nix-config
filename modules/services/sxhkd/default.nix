{ pkgs, ... }:

{
  services = {
    sxhkd = {
      enable = true;
      keybindings = {
     
        # Apps
        "super + Return" = "alacritty";											# Open Terminal
        "super + space" = "rofi -show drun";										# Open Rofi (custome theme " -theme theme.rasi")

        # Bspwm
        "super + {q,k}" = "bspc node -{c,k}";										# Close or Kill
        "super + Escape" = "bspc quit";											# Exit WM
        "super + r" = "bspc wm -r";											# Reload WM

        # Super - Nodes
        "super + {_,shift +}{Left, Right, Up, Down}" = "bspc node -{f,s} {west,east,north,south}";			# Focus or move node in given direction
        "super + m" = "bspc desktop -l next";										# Alternate between the tiled and monocle layout
        "super + g" = "bspc node -s biggest.window";									# Swap current node and the biggest window
   
        # Alt - Move workspaces
        "alt + {Left,Right}" = "bspc desktop -f {prev,next}.local"; 							# Focus the next/previous desktop in the current monitor
        "alt + {_,shift +}{ampersand,eacute,quotedbl,apostrophe,parenleft,section,egrave,exclam,ccedilla,agrave}" = "bspc {desktop -f,node -d} '^{1-9,10}'"; # Focus or send to the given desktop

        # Control - Resize
        "control + {Left, Right, Up, Down}" = "bspc node -z {left -20 0, right 20 0, top 0 -20, bottom 0 20}";		# Expand window by moving one of its sides outwards
	"control + shift + {Left, Right, Up, Down}" = "bspc node -z { right -20 0, left 20 0, bottom 0 -20, top 0 20}";	# Contract window my moving one of its sides inwards
      };
    };
  };
}
