#
#  Bspwm Configuration
#  Enable with "bspwm.enable = true;"
#

{ config, lib, pkgs, vars, host, ... }:

with lib;
with host;
let
  monitor =
    if hostName == "beelink" then
      "${pkgs.xorg.xrandr}/bin/xrandr --output ${secondMonitor} --mode 1920x1080 --pos 0x0 --rotate normal --output ${mainMonitor} --primary --mode 1920x1080 --pos 1920x0 --rotate normal"
    else if hostName == "vm" || hostName == "probook" then
      "${pkgs.xorg.xrandr}/bin/xrandr --mode 1920x1080 --pos 0x0 --rotate normal"
    else false;

  extra = ''
    killall -q polybar &                            # Kill polybar
    while pgrep -u $UID -x polybar >/dev/null; do sleep 1;done

    WORKSPACES                                      # Workspace Tags

    bspc config border_width      3
    bspc config window_gaps      12
    bspc config split_ratio     0.5

    bspc config click_to_focus            true
    bspc config focus_follows_pointer     false
    bspc config borderless_monocle        false
    bspc config gapless_monocle           false

    #bspc config normal_border_color  "#000000"
    #bspc config focused_border_color "#ffffff"

    #pgrep -x sxhkd > /dev/null || sxhkd &

    feh --bg-tile $HOME/.config/wall.png            # Wallpaper

    polybar main & #2>~/log &
  '';

  extraConf = builtins.replaceStrings [ "WORKSPACES" ]
  [
    (if hostName == "beelink" then ''
      bspc monitor ${mainMonitor} -d 1 2 3 4 5
      bspc monitor ${secondMonitor} -d 6 7 8 9 0
      bspc wm -O ${mainMonitor} ${secondMonitor}
      polybar sec &
    ''
    else if hostName == "vm" || hostName == "probook" then ''
      bspc monitor -d 1 2 3 4 5
    ''
    else false)
  ]
  "${extra}";
in
{
  options = {
    bspwm = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (config.bspwm.enable)
  {
    x11wm.enable = true;                            # X11 Window Manager

    services = {
      xserver = {
        enable = true;

        layout = "us";
        xkbOptions = "eurosign:e";
        libinput = {
          enable = true;
          touchpad = {
            tapping = true;
            scrollMethod = "twofinger";
            naturalScrolling = true;
            accelProfile = "adaptive";
            disableWhileTyping = true;
          };
        };
        modules = [ pkgs.xf86_input_wacom ];
        wacom.enable = true;

        displayManager = {                          # Display Manager
          lightdm = {
            enable = true;
            background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
            greeters = {
              gtk = {
                theme = {
                  name = "Dracula";
                  package = pkgs.dracula-theme;
                };
                cursorTheme = {
                  name = "Dracula-cursors";
                  package = pkgs.dracula-theme;
                  size = 16;
                };
              };
            };
          };
          defaultSession = "none+bspwm";
        };
        windowManager= {
          bspwm = {                                 # Window Manager
            enable = true;
          };
        };

        displayManager.sessionCommands = monitor;

        serverFlagsSection = ''
          Option "BlankTime" "0"
          Option "StandbyTime" "0"
          Option "SuspendTime" "0"
          Option "OffTime" "0"
        '';                                         # Disable Sleep

        resolutions = [
          { x = 1920; y = 1080; }
          { x = 1600; y = 900; }
          { x = 3840; y = 2160; }
        ];
      };
    };

    programs.zsh.enable = true;                     # Required for Default User

    environment.systemPackages = with pkgs; [       # System-Wide Packages
      xclip             # Clipboard
      xorg.xev          # Event Viewer
      xorg.xkill        # Process Killer
      xorg.xrandr       # Monitor Settings
      xterm             # Terminal
    ];

    home-manager.users.${vars.user} = {
      xsession = {
        enable = true;
        numlock.enable = true;
        windowManager = {
          bspwm = {
            enable = true;
            monitors = if hostName == "beelink" then {
              ${mainMonitor} = [ "1" "2" "3" "4" "5" ];
              ${secondMonitor} = [ "6" "7" "8" "9" "0" ];
            } else {};
            rules = {                               # Window Rules (xprop)
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
              "*:*:Picture in picture" = {
                state = "floating";
                sticky = true;
              };
              "*:*:Picture-in-Picture" = {
                state = "floating";
                sticky = true;
              };
              "Steam" = {
                desktop = "5";
              };
            };
            extraConfig = extraConf;
          };
        };
      };
    };
  };
}
