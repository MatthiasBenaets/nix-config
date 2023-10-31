{ config, lib, pkgs, ... }:

{
    programs.waybar = {
      enable = true;
      package = nixpkgs-wayland.packages."x86_64-linux".waybar; 
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = ''
               * {
                 font-family: "JetBrainsMono Nerd Font";
                 font-size: 12pt;
                 font-weight: bold;
                 border-radius: 0px;
                 transition-property: background-color;
                 transition-duration: 0.5s;
               }
               @keyframes blink_red {
                 to {
                   background-color: rgb(242, 143, 173);
                   color: rgb(26, 24, 38);
                 }
               }
               .warning, .critical, .urgent {
                 animation-name: blink_red;
                 animation-duration: 1s;
                 animation-timing-function: linear;
                 animation-iteration-count: infinite;
                 animation-direction: alternate;
               }
               window#waybar {
                 background-color: transparent;
               }
               window > box {
                 margin-left: 5px;
                 margin-right: 5px;
                 margin-top: 5px;
                 background-color: rgb(30, 30, 46);
               }
         #workspaces {
                 padding-left: 0px;
                 padding-right: 4px;
               }
         #workspaces button {
                 padding-top: 5px;
                 padding-bottom: 5px;
                 padding-left: 6px;
                 padding-right: 6px;
               }
         #workspaces button.active {
                 background-color: rgb(181, 232, 224);
                 color: rgb(26, 24, 38);
               }
         #workspaces button.urgent {
                 color: rgb(26, 24, 38);
               }
         #workspaces button:hover {
                 background-color: rgb(248, 189, 150);
                 color: rgb(26, 24, 38);
               }
               tooltip {
                 background: rgb(48, 45, 65);
               }
               tooltip label {
                 color: rgb(217, 224, 238);
               }
         #custom-launcher {
                 font-size: 20px;
                 padding-left: 8px;
                 padding-right: 6px;
                 color: #7ebae4;
               }
         #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
                 padding-left: 10px;
                 padding-right: 10px;
               }
               /* #mode { */
               /* 	margin-left: 10px; */
               /* 	background-color: rgb(248, 189, 150); */
               /*     color: rgb(26, 24, 38); */
               /* } */
         #memory {
                 color: rgb(181, 232, 224);
               }
         #cpu {
                 color: rgb(245, 194, 231);
               }
         #clock {
                 color: rgb(217, 224, 238);
               }
        /* #idle_inhibitor {
                 color: rgb(221, 182, 242);
               }*/
         #custom-wall {
                 color: rgb(221, 182, 242);
            }
         #temperature {
                 color: rgb(150, 205, 251);
               }
         #backlight {
                 color: rgb(248, 189, 150);
               }
         #pulseaudio {
                 color: rgb(245, 224, 220);
               }
         #network {
                 color: #ABE9B3;
               }

         #network.disconnected {
                 color: rgb(255, 255, 255);
               }
         #battery.charging, #battery.full, #battery.discharging {
                 color: rgb(250, 227, 176);
               }
         #battery.critical:not(.charging) {
                 color: rgb(242, 143, 173);
               }
         #custom-powermenu {
                 color: rgb(242, 143, 173);
               }
         #tray {
                 padding-right: 8px;
                 padding-left: 10px;
               }
         #mpd.paused {
                 color: #414868;
                 font-style: italic;
               }
         #mpd.stopped {
                 background: transparent;
               }
         #mpd {
                 color: #c0caf5;
               }
         #custom-cava-internal{
                 font-family: "Hack Nerd Font" ;
               }
      '';
      settings = [{
        "layer" = "top";
        "position" = "top";
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "temperature"
          #"idle_inhibitor"
          "custom/wall"
          "mpd"
          "custom/cava-internal"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "memory"
          "cpu"
          "network"
          "battery"
          "custom/powermenu"
          "tray"
        ];
        "custom/launcher" = {
          "format" = " ";
          "on-click" = "pkill rofi || ~/.config/rofi/launcher.sh";
          "tooltip" = false;
        };
        "custom/wall" = {
          "on-click" = "wallpaper_random";
          "on-click-middle" = "default_wall";
          "on-click-right" = "killall dynamic_wallpaper || dynamic_wallpaper &";
          "format" = " 󰠖 ";
          "tooltip" = false;
        };
        "custom/cava-internal" = {
          "exec" = "sleep 1s && cava-internal";
          "tooltip" = false;
        };
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
          "on-click" = "activate";
          # "on-scroll-up" = "hyprctl dispatch workspace e+1";
          # "on-scroll-down" = "hyprctl dispatch workspace e-1";
        };
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
          "tooltip" = false;
        };
        "backlight" = {
          "device" = "intel_backlight";
          "on-scroll-up" = "light -A 5";
          "on-scroll-down" = "light -U 5";
          "format" = "{icon} {percent}%";
          "format-icons" = [ "󰃝" "󰃞" "󰃟" "󰃠" ];
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{icon} {volume}%";
          "format-muted" = "󰖁 Muted";
          "format-icons" = {
            "default" = [ "" "" "" ];
          };
          "on-click" = "pamixer -t";
          "tooltip" = false;
        };
        "battery" = {
          "interval" = 10;
          "states" = {
            "warning" = 20;
            "critical" = 10;
          };
          "format" = "{icon} {capacity}%";
          "format-icons" = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          "format-full" = "{icon} {capacity}%";
          "format-charging" = "󰂄 {capacity}%";
          "tooltip" = false;
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%I:%M %p  %A %b %d}";
          "tooltip" = true;
          /* "tooltip-format"= "{=%A; %d %B %Y}\n<tt>{calendar}</tt>" */
          "tooltip-format" = "上午：高数\n下午：Ps\n晚上：Golang\n<tt>{calendar}</tt>";
        };
        "memory" = {
          "interval" = 1;
          "format" = "󰍛 {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "cpu" = {
          "interval" = 1;
          "format" = "󰻠 {usage}%";
        };
        "mpd" = {
          "max-length" = 25;
          "format" = "<span foreground='#bb9af7'></span> {title}";
          "format-paused" = " {title}";
          "format-stopped" = "<span foreground='#bb9af7'></span>";
          "format-disconnected" = "";
          "on-click" = "mpc --quiet toggle";
          "on-click-right" = "mpc update; mpc ls | mpc add";
          "on-click-middle" = "kitty --class='ncmpcpp' ncmpcpp ";
          "on-scroll-up" = "mpc --quiet prev";
          "on-scroll-down" = "mpc --quiet next";
          "smooth-scrolling-threshold" = 5;
          "tooltip-format" = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
        };
        "network" = {
          "format-disconnected" = "󰯡 Disconnected";
          "format-ethernet" = "󰀂 {ifname} ({ipaddr})";
          "format-linked" = "󰖪 {essid} (No IP)";
          "format-wifi" = "󰖩 {essid}";
          "interval" = 1;
          "tooltip" = false;
        };
        "temperature" = {
          # "hwmon-path"= "${env:HWMON_PATH}";
          #"critical-threshold"= 80;
          "tooltip" = false;
          "format" = " {temperatureC}°C";
        };
        "custom/powermenu" = {
          "format" = "";
          "on-click" = "pkill rofi || ~/.config/rofi/powermenu.sh";
          "tooltip" = false;
        };
        "tray" = {
          "icon-size" = 15;
          "spacing" = 5;
        };
      }];
    };
    #other config & style
    home.file = {
      ".config/waybar/light_config".text = ''
        [
          {
            "backlight": {
              "device": "intel_backlight",
              "format": "{icon} {percent}%",
              "format-icons": [
                "󰃝", "󰃞", "󰃟", "󰃠"
              ],
              "on-scroll-down": "light -U 5",
              "on-scroll-up": "light -A 5"
            },
            "battery": {
              "format": "{icon} {capacity}%",
              "format-charging": "󰂄 {capacity}%",
              "format-full": "{icon} {capacity}%",
              "format-icons": [
                "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"
              ],
              "interval": 10,
              "states": {
                "critical": 10,
                "warning": 20
              },
              "tooltip": false
            },
            "clock": {
              "format": "{:%I:%M %p  %A %b %d}",
              "interval": 1,
              "tooltip": true,
              "tooltip-format": "上午：高数\n下午：Ps\n晚上：Golang\n<tt>{calendar}</tt>"
            },
            "cpu": {
              "format": "󰻠 {usage}%",
              "interval": 1
            },
            "custom/cava-internal": {
              "exec": "sleep 1s && cava-internal",
              "tooltip": false
            },
            "custom/launcher": {
              "format": " ",
              "on-click": "pkill rofi || ~/.config/rofi/launcher.sh",
              "tooltip": false
            },
            "custom/wall": {
              "on-click": "wallpaper_random",
              "on-click-middle": "default_wall",
              "on-click-right": "killall dynamic_wallpaper || dynamic_wallpaper &",
              "format": " 󰠖 ",
              "tooltip": false
            },
            "custom/powermenu": {
              "format": "",
              "on-click": "pkill rofi || ~/.config/rofi/powermenu.sh",
              "tooltip": false
            },
            "idle_inhibitor": {
              "format": "{icon}",
              "format-icons": {
                "activated": "",
                "deactivated": ""
              },
              "tooltip": false
            },
            "layer": "top",
            "memory": {
              "format": "󰍛 {percentage}%",
              "interval": 1,
              "states": {
                "warning": 85
              }
            },
            "modules-center": [
              "clock"
            ],
            "modules-left": [
              "custom/launcher",
              "hyprland/workspaces",
              "temperature",
              //"idle_inhibitor",
              "custom/wall",
              "mpd",
              "custom/cava-internal"
            ],
            "modules-right": [
              "pulseaudio",
              "backlight",
              "memory",
              "cpu",
              "network",
              "battery",
              "custom/powermenu",
              "tray"
            ],
            "mpd": {
              "format": "<span foreground='#FF99FF'></span> {title}",
              "format-disconnected": "",
              "format-paused": " {title}",
              "format-stopped": "<span foreground='#bb9af7'></span>",
              "max-length": 25,
              "on-click": "mpc --quiet toggle",
              "on-click-middle": "kitty --class='ncmpcpp' ncmpcpp ",
              "on-click-right": "mpc update; mpc ls | mpc add",
              "on-scroll-down": "mpc --quiet next",
              "on-scroll-up": "mpc --quiet prev",
              "smooth-scrolling-threshold": 5,
              "tooltip-format": "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})"
            },
            "network": {
              "interval": 1,
              "format-wifi": "󰖩 {essid}",
              "format-ethernet": "󰀂  {ifname} ({ipaddr})",
              "format-linked": "󰖪 {essid} (No IP)",
              "format-disconnected": "󰯡 Disconnected",
              "tooltip": false,
            },
            "position": "top",
            "pulseaudio": {
              "format": "{icon} {volume}%",
              "format-icons": {
                "default": [
                  "",
                  "",
                  ""
                ]
              },
              "format-muted": "󰖁 Muted",
              "on-click": "pamixer -t",
              "scroll-step": 1,
              "tooltip": false
            },
            "temperature": {
              "format": " {temperatureC}°C",
              "tooltip": false
            },
            "tray": {
              "icon-size": 15,
              "spacing": 5
            },
            "hyprland/workspaces": {
              "format": "{icon}",
              "on-click": "activate",
              "active-only": false,
            }
          }
        ]
      '';
      ".config/waybar/light_style.css".text = ''
              * {
                font-family: "JetBrainsMono Nerd Font";
                font-size: 12pt;
                font-weight: bold;
                border-radius: 0px;
                transition-property: background-color;
                transition-duration: 0.5s;
              }
              @keyframes blink_red {
                to {
                  background-color: rgb(242, 143, 173);
                  color: rgb(26, 24, 38);
                }
              }
              .warning, .critical, .urgent {
                animation-name: blink_red;
                animation-duration: 1s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                animation-direction: alternate;
              }
              window#waybar {
                background-color: transparent;
              }
              window > box {
                margin-left: 5px;
                margin-right: 5px;
                margin-top: 5px;
                background-color: rgb(250, 244, 252);
              }
        #workspaces {
                padding-left: 0px;
                padding-right: 4px;
              }
        #workspaces button {
                padding-top: 5px;
                padding-bottom: 5px;
                padding-left: 6px;
                padding-right: 6px;
                color:#99CCFF;
              }
        #workspaces button.active {
                background-color: rgb(181, 232, 224);
                color: rgb(26, 24, 38);
              }
        #workspaces button.urgent {
                color: rgb(26, 24, 38);
              }
        #workspaces button:hover {
                background-color: #CCCCFF;
                color: rgb(26, 24, 38);
              }
              tooltip {
                /* background: rgb(250, 244, 252); */
                background: rgb(250, 244, 252);
              }
              tooltip label {
                color: rgb(65, 72, 104);
              }
        #custom-launcher {
                font-size: 20px;
                padding-left: 8px;
                padding-right: 6px;
                color: #7ebae4;
              }
        #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
                padding-left: 10px;
                padding-right: 10px;
              }
              /* #mode { */
              /* 	margin-left: 10px; */
              /* 	background-color: rgb(248, 189, 150); */
              /*     color: rgb(26, 24, 38); */
              /* } */
        #memory {
                color: #66CCFF;
              }
        #cpu {
                color: #FF99FF;
              }
        #clock {
                color: rgb(65, 72, 104);
              }
        /*
        #idle_inhibitor {
        color: #FF6699;
        }*/
        #custom-wall {
                color: #FF6699;
              }
        #temperature {
                color: #9933FF;
              }
        #backlight {
                color: #6666FF;
              }
        #pulseaudio {
                color: #FF9900;
              }
        #network {
                color: #00CC66;
              }

        #network.disconnected {
                color: #99CCCC;
              }
        #battery.charging, #battery.full, #battery.discharging {
                color: #FF99CC;
              }
        #battery.critical:not(.charging) {
                color: rgb(242, 143, 173);
              }
        #custom-powermenu {
                color: #FF0066;
              }
        #tray {
                padding-right: 8px;
                padding-left: 10px;
              }
        #tray menu {
                background: rgb(250, 244, 252);
                color:rgb(192, 202, 245);
        }
        #mpd.paused {
                color: rgb(192, 202, 245);
                font-style: italic;
              }
        #mpd.stopped {
                background: transparent;
              }
        #mpd {
                  color: rgb(65, 72, 104);

                /* color: #c0caf5; */
              }
        #custom-cava-internal{
                font-family: "Hack Nerd Font" ;
              }
      '';
    };
    home.file = {
      ".config/waybar/nord_config".text = ''
              [
          {
            "backlight": {
              "device": "intel_backlight",
              "format": "{icon} {percent}%",
              "format-icons": [
                "󰃝", "󰃞", "󰃟", "󰃠"
              ],
              "on-scroll-down": "light -U 5",
              "on-scroll-up": "light -A 5"
            },
            "battery": {
              "format": "{icon} {capacity}%",
              "format-charging": "󰂄 {capacity}%",
              "format-full": "{icon} {capacity}%",
              "format-icons": [
              "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"
              ],
              "interval": 10,
              "states": {
                "critical": 10,
                "warning": 20
              },
              "tooltip": false
            },
            "clock": {
              "format": "{:%I:%M %p  %A %b %d}",
              "interval": 1,
              "tooltip": true,
              "tooltip-format": "上午：高数\n下午：Ps\n晚上：Golang\n<tt>{calendar}</tt>"
            },
            "cpu": {
              "format": "󰻠 {usage}%",
              "interval": 1
            },
            "custom/cava-internal": {
              "exec": "sleep 1s && cava-internal",
              "tooltip": false
            },
            "custom/launcher": {
              "format": " ",
              "on-click": "pkill rofi || ~/.config/rofi/launcher.sh",
              "tooltip": false
            },
            "custom/wall": {
              "on-click": "wallpaper_random",
              "on-click-middle": "default_wall",
              "on-click-right": "killall dynamic_wallpaper || dynamic_wallpaper &",
              "format": " 󰠖 ",
              "tooltip": false
            },
            "custom/powermenu": {
              "format": "",
              "on-click": "pkill rofi || ~/.config/rofi/powermenu.sh",
              "tooltip": false
            },
            "idle_inhibitor": {
              "format": "{icon}",
              "format-icons": {
                "activated": "",
                "deactivated": ""
              },
              "tooltip": false
            },
            "layer": "top",
            "memory": {
              "format": "󰍛 {percentage}%",
              "interval": 1,
              "states": {
                "warning": 85
              }
            },
            "modules-center": [
              "clock"
            ],
            "modules-left": [
              "custom/launcher",
              "hyprland/workspaces",
              "temperature",
              //"idle_inhibitor",
              "custom/wall",
              "mpd",
              "custom/cava-internal"
            ],
            "modules-right": [
              "pulseaudio",
              "backlight",
              "memory",
              "cpu",
              "network",
              "battery",
              "custom/powermenu",
              "tray"
            ],
            "mpd": {
              "format": "<span foreground='#8EBBBA'></span> {title}",
              "format-disconnected": "",
              "format-paused": " {title}",
              "format-stopped": "<span foreground='#bb9af7'></span>",
              "max-length": 25,
              "on-click": "mpc --quiet toggle",
              "on-click-middle": "kitty --class='ncmpcpp' ncmpcpp ",
              "on-click-right": "mpc update; mpc ls | mpc add",
              "on-scroll-down": "mpc --quiet next",
              "on-scroll-up": "mpc --quiet prev",
              "smooth-scrolling-threshold": 5,
              "tooltip-format": "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})"
            },
            "network": {
              "format-disconnected": "󰯡 Disconnected",
              "format-ethernet": "󰀂 {ifname} ({ipaddr})",
              "format-linked": "󰖪 {essid} (No IP)",
              "format-wifi": "󰖩 {essid}",
              "interval": 1,
              "tooltip": false
            },
            "position": "top",
            "pulseaudio": {
              "format": "{icon} {volume}%",
              "format-icons": {
                "default": [
                  "",
                  "",
                  ""
                ]
              },
              "format-muted": "󰖁 Muted",
              "on-click": "pamixer -t",
              "scroll-step": 1,
              "tooltip": false
            },
            "temperature": {
              "format": " {temperatureC}°C",
              "tooltip": false
            },
            "tray": {
              "icon-size": 15,
              "spacing": 5
            },
            "hyprland/workspaces": {
              "format": "{icon}",
              "on-click": "activate",
              "active-only": false,
            }
          }
        ]

      '';
      ".config/waybar/nord_style.css".text = ''
              * {
                font-family: "JetBrainsMono Nerd Font";
                font-size: 12pt;
                font-weight: bold;
                border-radius: 0px;
                transition-property: background-color;
                transition-duration: 0.5s;
              }
              @keyframes blink_red {
                to {
                  background-color: rgb(242, 143, 173);
                  color: rgb(26, 24, 38);
                }
              }
              .warning, .critical, .urgent {
                animation-name: blink_red;
                animation-duration: 1s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                animation-direction: alternate;
              }
              window#waybar {
                background-color: transparent;
              }
              window > box {
                margin-left: 5px;
                margin-right: 5px;
                margin-top: 5px;
                background-color: #3b4252;
              }
        #workspaces {
                padding-left: 0px;
                padding-right: 4px;
              }
        #workspaces button {
                padding-top: 5px;
                padding-bottom: 5px;
                padding-left: 6px;
                padding-right: 6px;
                color:#D8DEE9;
              }
        #workspaces button.active {
                background-color: rgb(181, 232, 224);
                color: rgb(26, 24, 38);
              }
        #workspaces button.urgent {
                color: rgb(26, 24, 38);
              }
        #workspaces button:hover {
                background-color: #B38DAC;
                color: rgb(26, 24, 38);
              }
              tooltip {
                /* background: rgb(250, 244, 252); */
                background: #3b4253;
              }
              tooltip label {
                color: #E4E8EF;
              }
        #custom-launcher {
                font-size: 20px;
                padding-left: 8px;
                padding-right: 6px;
                color: #7ebae4;
              }
        #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
                padding-left: 10px;
                padding-right: 10px;
              }
              /* #mode { */
              /* 	margin-left: 10px; */
              /* 	background-color: rgb(248, 189, 150); */
              /*     color: rgb(26, 24, 38); */
              /* } */
        #memory {
                color: #8EBBBA;
              }
        #cpu {
                color: #B38DAC;
              }
        #clock {
                color: #E4E8EF;
              }
        /*
        #idle_inhibitor {
        color: #FF6699;
        }*/
        #custom-wall {
                color: #B38DAC;
              }
        #temperature {
                color: #80A0C0;
              }
        #backlight {
                color: #A2BD8B;
              }
        #pulseaudio {
                color: #E9C98A;
              }
        #network {
                color: #99CC99;
              }

        #network.disconnected {
                color: #CCCCCC;
              }
        #battery.charging, #battery.full, #battery.discharging {
                color: #CF876F;
              }
        #battery.critical:not(.charging) {
                color: #D6DCE7;
              }
        #custom-powermenu {
                color: #BD6069;
              }
        #tray {
                padding-right: 8px;
                padding-left: 10px;
              }
        #tray menu {
                background: #3b4252;
                color: #DEE2EA;
        }
        #mpd.paused {
                color: rgb(192, 202, 245);
                font-style: italic;
              }
        #mpd.stopped {
                background: transparent;
              }
        #mpd {
                  color: #E4E8EF;

                /* color: #c0caf5; */
              }
        #custom-cava-internal{
                font-family: "Hack Nerd Font" ;
              }
      '';
    };
}
