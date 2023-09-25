#
#  Bar
#

{ config, lib, pkgs, unstable, vars, host, ...}:

with host;
let
  output =
    if hostName == "beelink" || hostName == "desktop" then [
      mainMonitor
      secondMonitor
    ] else if hostName == "work" then [
      mainMonitor
      secondMonitor
      thirdMonitor
    ] else [
      mainMonitor
    ];
  modules-left = with config.programs;
    if hyprland.enable == true then [
      "custom/menu" "hyprland/workspaces"
    ] else if sway.enable == true then [
      "sway/workspaces" "sway/window" "sway/mode"
    ] else [];

  modules-right =
    if hostName == "beelink" || hostName == "desktop" then [
      "custom/ds4" "custom/mouse" "custom/kb" "custom/pad" "network" "cpu" "memory" "custom/pad" "pulseaudio" "custom/sink" "custom/pad" "clock" "tray"
    ] else [
      "cpu" "memory" "custom/pad" "battery" "custom/pad" "backlight" "custom/pad" "pulseaudio" "custom/pad" "clock" "tray"
    ];

  sinkBuiltIn="Built-in Audio Analog Stereo";
  sinkVideocard=''Ellesmere HDMI Audio \[Radeon RX 470\/480 \/ 570\/580\/590\] Digital Stereo \(HDMI 3\)'';
  sinkBluetooth="S10 Bluetooth Speaker";
  headset=sinkBuiltIn;
  speaker=sinkBluetooth;
in
{
  config = lib.mkIf (config.wlwm.enable) {
    environment.systemPackages = with unstable; [
      waybar
    ];

    home-manager.users.${vars.user} = {
      programs.waybar = {
        enable = true;
        package = unstable.waybar;
        systemd ={
          enable = true;
          target = "sway-session.target";
        };

        style = ''
          * {
            border: none;
            font-family: FiraCode Nerd Font Mono;
            /*font-weight: bold;*/
            font-size: 12px;
            text-shadow: 0px 0px 5px #000000;
          }
          button:hover {
            background-color: rgba(80,100,100,0.4);
          }
          window#waybar {
            background-color: rgba(0,0,0,0.5);
            background: transparent;
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
          #custom-sink,
          #network,
          #mpd,
          #memory,
          #network,
          #window,
          #cpu,
          #disk,
          #backlight,
          #battery,
          #custom-mouse,
          #custom-kb,
          #custom-ds4,
          #tray {
            color: #999999;
            background-clip: padding-box;
          }
          #custom-menu {
            color: #A7C7E7;
            padding: 0px 5px 0px 5px;
          }
          #workspaces button {
            padding: 0px 5px;
            min-width: 5px;
            color: rgba(255,255,255,0.8);
          }
          #workspaces button:hover {
            background-color: rgba(0,0,0,0.2);
          }
          /*#workspaces button.focused {*/
          #workspaces button.active {
            color: rgba(255,255,255,0.8);
            background-color: rgba(80,100,100,0.4);
          }
          #workspaces button.visible {
            color: #ccffff;
          }
          #workspaces button.hidden {
            color: #999999;
          }
          #battery.warning {
            color: #ff5d17;
            background-color: rgba(0,0,0,0);
          }
          #battery.critical {
            color: #ff200c;
            background-color: rgba(0,0,0,0);
          }
          #battery.charging {
            color: #9ece6a;
            background-color: rgba(0,0,0,0);
          }
        '';
        settings = {
          Main = {
            layer = "top";
            position = "top";
            height = 16;
            output = output;

            tray = { spacing = 5; };
            modules-left = modules-left;
            modules-right = modules-right;

            "custom/pad" = {
              format = "      ";
              tooltip = false;
            };
            "custom/menu" = {
              format = "<span font='16'></span>";
              on-click = ''${unstable.eww-wayland}/bin/eww open --toggle menu --screen 0'';
              on-click-right = "${pkgs.wofi}/bin/wofi --show drun";
              tooltip = false;
            };
            "sway/workspaces" = {
              format = "<span font='12'>{icon}</span>";
              format-icons = {
                "1"="";
                "2"="";
                "3"="";
                "4"="";
                "5"="";
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
            "wlr/workspaces" = {
              format = "<span font='11'>{name}</span>";
              active-only = false;
              on-click = "activate";
            };
            "hyprland/workspaces" = {
              format = "<span font='11'>{name}</span>";
            };
            clock = {
              format = "{:%b %d %H:%M}  ";
              on-click = "${unstable.eww-wayland}/bin/eww open --toggle calendar --screen 0";
            };
            cpu = {
              format = " {usage}% <span font='11'></span> ";
              interval = 1;
            };
            disk = {
              format = "{percentage_used}% <span font='11'></span>";
              path = "/";
              interval = 30;
            };
            memory = {
              format = "{}% <span font='11'></span>";
              interval = 1;
            };
            backlight = {
              device = "intel_backlight";
              format= "{percent}% <span font='11'>{icon}</span>";
              format-icons = ["" ""];
              on-scroll-down = "${pkgs.light}/bin/light -U 5";
              on-scroll-up = "${pkgs.light}/bin/light -A 5";
            };
            battery = {
              interval = 60;
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{capacity}% <span font='11'>{icon}</span>";
              format-charging = "{capacity}% <span font='11'></span>";
              format-icons = ["" "" "" "" ""];
              max-length = 25;
            };
            network = {
              format-wifi = "<span font='11'></span>";
              format-ethernet = "<span font='11'>󰈀</span>";
              format-linked = "<span font='11'>󱘖</span> {ifname} (No IP)";
              format-disconnected = "<span font='11'>󱘖</span> Not connected";
              tooltip-format = "{essid} {ipaddr}/{cidr}";
            };
            pulseaudio = {
              format = "<span font='11'>{icon}</span> {volume}% {format_source} ";
              format-bluetooth = "<span font='11'>{icon}</span> {volume}% {format_source} ";
              format-bluetooth-muted = "<span font='11'>x</span> {volume}% {format_source} ";
              format-muted = "<span font='11'>x</span> {volume}% {format_source} ";
              format-source = "<span font='10'></span> ";
              format-source-muted = "<span font='11'> </span> ";
              format-icons = {
                default = [ "" "" "" ];
                headphone = "";
              };
              tooltip-format = "{desc}, {volume}%";
              on-click = "${pkgs.pamixer}/bin/pamixer -t";
              on-click-right = "${pkgs.pamixer}/bin/pamixer --default-source -t";
              on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
            };
            "custom/sink" = {
              format = "{}";
              exec = "$HOME/.config/waybar/script/sink.sh";
              interval = 2;
              on-click = "$HOME/.config/waybar/script/switch.sh";
              tooltip = false;
            };
            "custom/mouse" = {
              format = "{}";
              exec = "$HOME/.config/waybar/script/mouse.sh";
              interval = 60;
            };
            "custom/kb" = {
              format = "{}";
              exec = "$HOME/.config/waybar/script/kb.sh";
              interval = 60;
            };
            "custom/ds4" = {
              format = "{}";
              exec = "$HOME/.config/waybar/script/ds4.sh";
              interval = 60;
            };
            tray = {
              icon-size = 13;
            };
          };
        };
      };
      home.file = {
        ".config/waybar/script/sink.sh" = {
          text = ''
            #!/bin/sh

            HEAD=$(awk '/ ${headset}/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)
            SPEAK=$(awk '/ ${speaker}/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)

            if [[ $HEAD = "*" ]]; then
              printf "<span font='13'></span>\n"
            elif [[ $SPEAK = "*" ]]; then
              printf "<span font='10'>󰓃</span>\n"
            fi
            exit 0
          '';
          executable = true;
        };
        ".config/waybar/script/switch.sh" = {
          text = ''
            #!/bin/sh

            ID1=$(awk '/ ${headset}/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | head -n 1)
            ID2=$(awk '/ ${speaker}/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | sed -n 2p)

            HEAD=$(awk '/ ${headset}/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)
            SPEAK=$(awk '/ ${speaker}/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)

            if [[ $SPEAK = "*" ]]; then
              ${pkgs.wireplumber}/bin/wpctl set-default $ID1
            elif [[ $HEAD = "*" ]]; then
              ${pkgs.wireplumber}/bin/wpctl set-default $ID2
            fi
            exit 0
          '';
          executable = true;
        };
        ".config/waybar/script/mouse.sh" = {
          text = ''
            #!/bin/sh

            for cap in /sys/class/power_supply/hidpp_battery_*/capacity; do
              BATT=$(cat "$cap")
            done
            for stat in /sys/class/power_supply/hidpp_battery_*/status; do
              STAT=$(cat "$stat")
            done

            if [[ "$STAT" = "Charging" ]] then
              printf "<span font='13'> 󰍽</span><span font='10'></span> $BATT%%\n"
            elif [[ "$STAT" = "Full" ]] then
              printf "<span font='13'> 󰍽</span><span font='10'></span> Full\n"
            elif [[ "$STAT" = "Discharging" ]] then
              printf "<span font='13'> 󰍽</span> $BATT%%\n"
            else
              printf "\n"
            fi

            exit 0
          '';
          executable = true;
        };
        ".config/waybar/script/kb.sh" = {
          text = ''
            #!/bin/sh

            for cap in /sys/class/power_supply/hid-dc:2c:26:36:79:9b-battery/capacity; do
              BATT=$(cat "$cap")
            done
            for stat in /sys/class/power_supply/hid-dc:2c:26:36:79:9b-battery/status; do
              STAT=$(cat "$stat")
            done

            if [[ "$STAT" == "Charging" ]] then
              printf "<span font='13'> 󰌌</span><span font='10'></span> $BATT%%\n"
            elif [[ "$STAT" == "Full" ]] then
              printf "<span font='13'> 󰌌</span><span font='10'></span> Full\n"
            elif [[ "$STAT" = "Discharging" ]] then
              printf "<span font='13'> 󰌌</span> $BATT%%\n"
            else
              printf "\n"
            fi

            exit 0
          '';
          executable = true;
        };
        ".config/waybar/script/ds4.sh" = {
          text = ''
            #!/bin/sh

            for cap in /sys/class/power_supply/*e8:47:3a:05:c0:2b/capacity; do
              BATT=$(cat "$cap")
            done
            for stat in /sys/class/power_supply/*e8:47:3a:05:c0:2b/status; do
              STAT=$(cat "$stat")
            done

            if [[ "$STAT" == "Charging" ]] then
              printf "<span font='13'> 󰊴</span><span font='10'></span> $BATT%%\n"
            elif [[ "$STAT" == "Full" ]] then
              printf "<span font='13'> 󰊴</span><span font='10'></span> Full\n"
            elif [[ "$STAT" = "Discharging" ]] then
              printf "<span font='13'> 󰊴</span> $BATT%%\n"
            else
              printf "\n"
            fi

            exit 0
          '';
          executable = true;
        };
      };
    };
  };
}
