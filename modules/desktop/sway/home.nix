{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;                          # Enable sway-session.target to link to graphical-session.target for systemd
    config = rec {                                      # Sway configuration
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.dmenu}/bin/dmenu_run";

      startup = [                                       # Run commands on Sway startup
        {command = "${pkgs.autotiling}/bin/autotiling"; always = true;} # Tiling Script
        {command = ''
          ${pkgs.swayidle}/bin/swayidle \
            timeout 120 '${pkgs.swaylock-fancy}/bin/swaylock-fancy' \
            timeout 240 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
            before-sleep 'swaylock-fancy'
        ''; always = true;}
      ];

      bars = [];                                        # No bar because using Waybar

      fonts = {                                         # Font usedfor window tiles, navbar, ...
        names = [ "Source Code Pro" ];
        size = 10.0;
      };

      gaps = {                                          # Gaps for containters
        inner = 3;
        outer = 3;
      };

      input = {                                         # Input modules
        "type:keyboard" = {
          xkb_layout = "us";
        };
      };

      keybindings = {                                   # Hotkeys
        "${modifier}+Return" = "exec ${terminal}";      # Open terminal
        "${modifier}+q" = "kill";                       # Kill container
        "${modifier}+r" = "reload";                     # Reload env
        "${modifier}+space" = "exec ${menu}";           # Open menu
        
        "${modifier}+Left" = "focus left";              # Focus container in workspace
        "${modifier}+Right" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Down" = "focus down";
        
        "${modifier}+Shift+Left" = "move left";         # Move container in workspace
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Down" = "move down";

        "Alt+Left" = "workspace prev";                  # Navigate to previous or next workspace if it exists
        "Alt+Right" = "workspace next";

        "Alt+1" = "workspace number 1";                 # Open workspace x
        "Alt+2" = "workspace number 2";
        "Alt+3" = "workspace number 3";
        "Alt+4" = "workspace number 4";
        "Alt+5" = "workspace number 5";

        "Alt+Shift+Left" = "move container to workspace prev, workspace prev";    # Move container to next available workspace and focus
        "Alt+Shift+Right" = "move container to workspace next, workspace next";

        "Alt+Shift+1" = "move container to workspace number 1";     # Move container to specific workspace
        "Alt+Shift+2" = "move container to workspace number 2";
        "Alt+Shift+3" = "move container to workspace number 3";
        "Alt+Shift+4" = "move container to workspace number 4";
        "Alt+Shift+5" = "move container to workspace number 5";

        "Control+Up" = "resize shrink height 20px";     # Resize container
        "Control+Down" = "resize grow height 20px";
        "Control+Left" = "resize shrink width 20px";
        "Control+Right" = "resize grow width 20px";

        "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui"; # Screenshots

        #"XF86AudioLowerVolume = "exec ${pkgs.pamixer}/bin/pamixer -d 10;   #Volume control
        #"XF86AudioRaiseVolume = "exec ${pkgs.pamixer}/bin/pamixer -i 10;
        #"XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";           #Media control
        #"XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        #"XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        #"XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        #
        #"XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U  5";    # Display brightness control
        #"XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
      };
    };
    #extraConfig = ''
    #  output <display> {
    #    mode 1920x1080@60Hz
    #  }
    #'';                                    # $ swaymsg -t get_outputs
    #extraSessionCommands = ''
    #  export WLR_NO_HARDWARE_CURSORS="1";  # Needed for cursor in vm
    #'';
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        border: none;
        font-family: FiraCode Nerd Font Mono;
        font-weight: bold;
      }

      window#waybar {
        background-color: #1a1b26;
        /*background: transparent;*/
        transition-property: background-color;
        transition-duration: .5s;
        border-bottom: none;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspace,
      #mode,
      #clock,
      #pulseaudio,
      #network,
      #mpd,
      #memory,
      #network,
      #window,
      #cpu,
      #disk,
      #tray {
        background-color: #252734;
        padding: 0 12px;
        margin: 4px 4px 4px 4px;
        border-radius: 90px;
        background-clip: padding-box;
      }

      #workspaces button {
        padding: 0 5px;
        color: #7aa2f7;
        min-width: 20px;
      }

      #workspaces button:hover {
        background-color: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.focused {
        color: #c678dd;
      }

      #workspaces button.urgent {
        color: #e06c75;
      }

      #mode {
        color: #e06c75;
      }

      #disk {
        color: #56b6c2;
      }

      #cpu {
        color: #d19a66;
      }

      #memory {
        color: #c678dd;
      }

      #clock {
        color: #7aa2f7;
      }

      #window {
        color: #9ece6a;
      }

      #network {
        color: #c678dd;
      }

      #pulseaudio {
        color: #d19a66;
      }

      #pulseaudio.muted {
        color: #c678dd;
        background-color: #252734;
      }
    '';
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      output = [
        "eDP-1"
      ];
      tray = { spacing = 10; };
      modules-center = [ "clock" ];
      modules-left = [ "sway/workspaces" "cpu" "disk" "memory" "sway/window" "sway/mode" ];
      modules-right = [ "network" "pulseaudio" "tray"];

      "sway/workspaces" = {
        format = "<span font='13'>{icon}</span>";
        format-icons = {
          "1"="";
          "2"="";
          "3"="";
          "4"="";
          "5"="";
        };
        all-outputs = true;
        persistent_workspaces = {
           "1" = [];
           "2" = [];
           "3" = [];
           "4" = [];
           "5" = [];
        };
      };
      clock = {
        format = "{:%b %d %H:%M} <span font='13'></span>";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%A, %B %d, %Y} ";
      };
      cpu = {
        format = "{usage}% <span font='13'></span>";
        tooltip = false;
        interval = 1;
      };
      disk = {
        format = "{percentage_used}% <span font='13'></span>";
        path = "/";
        interval = 30;
      };
      memory = {
        format = "{}% <span font='13'></span>";
        interval = 1;
      };
      network = {
        format-wifi = "<span font='13'></span>";
        format-ethernet = "<span font='13'></span> {ifname}: {ipaddr}/{cidr}";
        format-linked = "<span font='13'></span> {ifname} (No IP)";
        format-disconnected = "<span font='12'>睊</span> Not connected";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        tooltip-format = "<span font='13'></span> {essid} {signalStrength}%";
      };
      pulseaudio = {
        format = "<span font='13'>{icon}</span> {volume}% {format_source}";
        format-bluetooth = "<span font='13'>{icon}</span> {volume}% {format_source}";
        format-bluetooth-muted = "<span font='13'></span> {volume}% {format_source}";
        format-muted = "<span font='13'></span> {format_source}";
        format-source = "{volume}% <span font='11'></span>";
        format-source-muted = "<span font='11'></span>";
        format-icons = {
          default = [ "" "" "" ];
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
        };
        tooltip-format = "{desc}, {volume}%";
        on-click = "pamixer -t";
        on-click-right = "${pkgs.pamixer}/bin/pamixer -t";
        on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      tray = {
        icon-size = 16;
      };
    }];
  };

  #services = {                             # Dynamic display configuration
  #  kanshi = {
  #    enable = true;
  #    profiles = {
  #      screen1 = {                        # Profile 1
  #        outputs = [{
  #          criteria = "<display> or wildcard *";
  #          mode = "1920x1080@60Hz";
  #        }];
  #      };
  #      screen2 = {                        # Profile 2
  #        outputs = [
  #          {
  #            criteria = "<display1>";
  #            mode = "1920x1080@60Hz";
  #          }
  #          {
  #            criteria = "<display2";
  #            mode = "1920x1080@60Hz";
  #          }
  #        ];
  #      };
  #    };
  #  };
  #};
}
