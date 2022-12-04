#
#  Bspwm Home manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ home.nix
#   ├─ ./modules
#   │   └─ ./desktop
#   │       └─ ./bspwm
#   │           └─ home.nix *
#   └─ ./services
#       ├─ ./flameshot.nix
#       ├─ ./picom.nix
#       ├─ ./polybar.nix
#       └─ ./sxhkd.nix

{ config, lib, pkgs, host, ... }:

let
  extra = ''
    WORKSPACES                              # Workspace tag names (need to be the same as the polybar config to work)

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
  '';

  extraConf = with host; builtins.replaceStrings [ "WORKSPACES" ]
  [
    (if hostName == "desktop" then ''
      bspc monitor ${mainMonitor} -d 1 2 3 4 5
      bspc monitor ${secondMonitor} -d 6 7 8 9 0
      bspc wm -O ${mainMonitor} ${secondMonitor}
      polybar sec &
    ''
    else if hostName == "laptop" || hostName == "vm" then ''
      bspc monitor -d 1 2 3 4 5
    ''
    else false)
  ]
  "${extra}";
in
{
  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager = {
      bspwm = {
        enable = true;
        monitors = with host; if hostName == "desktop" then {
          ${mainMonitor} = [ "1" "2" "3" "4" "5" ];
          ${secondMonitor} = [ "6" "7" "8" "9" "0" ];
        } else {};                              # Multiple Monitors
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
        extraConfig = extraConf;
      };
    };
  };
}
