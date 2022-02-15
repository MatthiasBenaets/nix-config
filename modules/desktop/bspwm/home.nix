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
#       monitors = {										# Multiple monitors
#          eDP-1 = [ "1" "2" "3" "4" "5" ];
#	};
        rules = {										# Specific rules for apps
          "Firefox" = {
	    desktop = "^2";
          };
          "Google-chrome" = {
            desktop = "^2";
          };
          "Pcmanfm" = {
	    state = "floating";
          };
#         "Gimp" = {
#           desktop = "^8";
#           state = "floating";
#           follow = true;
#         };
#         "Kupfer.py" = {
#           focus = true;
#         };
#         "Screenkey" = {
#           manage = false;
#         };
        };
	extraConfig = ''
          bspc monitor -d 1 2 3 4 5		# Workspace tag names (need to be the same as the polybar config to work)

          bspc config border_width	2
          bspc config window_gaps      12
          bspc config split_ratio     0.5
          
          #bspc config borderless_monocle	true
          #bspc config gapless_monocle		true

          feh --bg-scale $HOME/.config/wall

          killall -q polybar & 			# Reboot polybar to correctly show workspaces
          sleep 0.5; polybar top #2>~/log &	# To lazy to figure out systemd service order
        '';
      };
    };
  };
}
