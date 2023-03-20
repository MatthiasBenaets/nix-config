#
# Bar
#

{ config, lib, pkgs, host, user, ...}:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  # nixpkgs.overlays = [                                      # Waybar needs to be compiled with the experimental flag for wlr/workspaces to work (for now done with hyprland.nix)
  #   (self: super: {
  #     waybar = super.waybar.overrideAttrs (oldAttrs: {
  #       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  #       patchPhase = ''
  #         substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
  #       '';
  #     });
  #   })
  # ];

  home-manager.users.${user} = {                           # Home-manager waybar config
    programs.waybar = {
      enable = true;
      systemd ={
        enable = true;
        target = "sway-session.target";                     # Needed for waybar to start automatically
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
      settings = with host; {
        Main = {
          layer = "top";
          position = "top";
          height = 16;
          output = [
            "${mainMonitor}"
          ];
          tray = { spacing = 5; };
          #modules-center = [ "clock" ];
          modules-left = with config;
            if programs.hyprland.enable == true then
              [ "custom/menu" "wlr/workspaces" ]
            else if programs.sway.enable == true then
              [ "sway/workspaces" "sway/window" "sway/mode" ]
            else [];

          modules-right =
            if hostName == "desktop" then
              [ "custom/ds4" "custom/pad" "network" "cpu" "memory" "custom/pad" "pulseaudio" "custom/sink" "custom/pad" "clock" "tray" ]
            else
              [ "cpu" "memory" "custom/pad" "battery" "custom/pad" "backlight" "custom/pad" "pulseaudio" "custom/pad" "clock" "tray" ];

          "custom/pad" = {
            format = "      ";
            tooltip = false;
          };
          "custom/menu" = {
            format = "<span font='16'></span>";
            #on-click = ''${pkgs.rofi}/bin/rofi -show power-menu -modi "power-menu:rofi-power-menu --choices=logout/suspend/reboot/shutdown"'';
            #on-click-right = "${pkgs.rofi}/bin/rofi -show drun";
            on-click = ''~/.config/wofi/power.sh'';
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
            #format = "<span font='12'>{icon}</span>";
            #format-icons = {
            #  "1"="";
            #  "2"="";
            #  "3"="";
            #  "4"="";
            #  "5"="";
            #  "6"="";
            #  "7"="";
            #  "8"="";
            #  "9"="";
            #  "10"="";
            #};
            #all-outputs = true;
            active-only = false;
            on-click = "activate";
          };
          clock = {
            format = "{:%b %d %H:%M}  ";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            #format-alt = "{:%A, %B %d, %Y} ";
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
            format-ethernet = "<span font='11'></span>";
            #format-ethernet = "<span font='11'></span> {ifname}: {ipaddr}/{cidr}";
            format-linked = "<span font='11'>睊</span> {ifname} (No IP)";
            format-disconnected = "<span font='11'>睊</span> Not connected";
            #format-alt = "{ifname}: {ipaddr}/{cidr}";
            tooltip-format = "{essid} {ipaddr}/{cidr}";
            #on-click-right = "${pkgs.alacritty}/bin/alacritty -e nmtui";
          };
          pulseaudio = {
            format = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth-muted = "<span font='11'>x</span> {volume}% {format_source} ";
            format-muted = "<span font='11'>x</span> {volume}% {format_source} ";
            #format-source = "{volume}% <span font='11'></span>";
            format-source = "<span font='10'></span> ";
            format-source-muted = "<span font='11'> </span> ";
            format-icons = {
              default = [ "" "" "" ];
              headphone = "";
              #hands-free = "";
              #headset = "";
              #phone = "";
              #portable = "";
              #car = "";
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
          "custom/ds4" = {
            format = "{}";
            exec = "$HOME/.config/waybar/script/ds4.sh";
            interval = 60;
          };
          tray = {
            icon-size = 13;
          };
        };
        Sec = if hostName == "desktop" || hostName == "work" then {
          layer = "top";
          position = "top";
          height = 16;
          output = [
            "${secondMonitor}"
          ];
          modules-left = [ "custom/menu" "wlr/workspaces" ];

          modules-right =
            if hostName == "desktop" then
              [ "custom/ds4" "custom/pad" "pulseaudio" "custom/sink" "custom/pad" "clock"]
            else
              [ "cpu" "memory" "custom/pad" "battery" "custom/pad" "backlight" "custom/pad" "pulseaudio" "custom/pad" "clock" ];

          "custom/pad" = {
            format = "      ";
            tooltip = false;
          };
          "custom/menu" = {
            format = "<span font='16'></span>";
            #on-click = "${pkgs.rofi}/bin/rofi -show p -modi p:${pkgs.rofi-power-menu}/bin/rofi-power-menu -theme $HOME/.config/rofi/config.rasi";
            #on-click-right = "${pkgs.rofi}/bin/rofi -show drun";
            on-click = ''~/.config/wofi/power.sh'';
            on-click-right = "${pkgs.wofi}/bin/wofi --show drun";
            tooltip = false;
          };
          "wlr/workspaces" = {
            format = "<span font='11'>{name}</span>";
            #format = "<span font='12'>{icon}</span>";
            #format-icons = {
            #  "1"="";
            #  "2"="";
            #  "3"="";
            #  "4"="";
            #  "5"="";
            #  "6"="";
            #  "7"="";
            #  "8"="";
            #  "9"="";
            #  "10"="";
            #};
            active-only = false;
            on-click = "activate";
            #on-scroll-up = "hyprctl dispatch workspace e+1";
            #on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          clock = {
            format = "{:%b %d %H:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            #format-alt = "{:%A, %B %d, %Y} ";
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
          pulseaudio = {
            format = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth-muted = "<span font='11'>x</span> {volume}% {format_source} ";
            format-muted = "<span font='11'>x</span> {volume}% {format_source} ";
            #format-source = "{volume}% <span font='11'></span> ";
            format-source = "<span font='10'></span> ";
            format-source-muted = "<span font='11'></span> ";
            format-icons = {
              default = [ "" "" "" ];
              headphone = "";
              #hands-free = "";
              #headset = "";
              #phone = "";
              #portable = "";
              #car = "";
            };
            tooltip-format = "{desc}, {volume}%";
            on-click = "${pkgs.pamixer}/bin/pamixer -t";
            on-click-right = "${pkgs.pamixer}/bin/pamixer --default-source -t";
            on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
          };
          "custom/sink" = {
            #format = "<span font='10'>蓼</span>";
            format = "{}";
            exec = "$HOME/.config/waybar/script/sink.sh";
            interval = 2;
            on-click = "$HOME/.config/waybar/script/switch.sh";
            tooltip = false;
          };
          "custom/ds4" = {
            format = "{}";
            exec = "$HOME/.config/waybar/script/ds4.sh";
            interval = 60;
          };
        } else {};
      };
    };
    home.file = {
      ".config/waybar/script/sink.sh" = {              # Custom script: Toggle speaker/headset
        text = ''
          #!/bin/sh

          HEAD=$(awk '/ Built-in Audio Analog Stereo/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | sed -n 2p)
          SPEAK=$(awk '/ S10 Bluetooth Speaker/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)

          if [[ $HEAD = "*" ]]; then
            printf "<span font='13'></span>\n"
          elif [[ $SPEAK = "*" ]]; then
            printf "<span font='10'>蓼</span>\n"
          fi
          exit 0
        '';
        executable = true;
      };
      ".config/waybar/script/switch.sh" = {              # Custom script: Toggle speaker/headset
        text = ''
          #!/bin/sh

          ID1=$(awk '/ Built-in Audio Analog Stereo/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | head -n 1)
          ID2=$(awk '/ S10 Bluetooth Speaker/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | sed -n 2p)

          HEAD=$(awk '/ Built-in Audio Analog Stereo/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | sed -n 2p)
          SPEAK=$(awk '/ S10 Bluetooth Speaker/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)

          if [[ $HEAD = "*" ]]; then
            ${pkgs.wireplumber}/bin/wpctl set-default $ID2
          elif [[ $SPEAK = "*" ]]; then
            ${pkgs.wireplumber}/bin/wpctl set-default $ID1
          fi
          exit 0
        '';
        executable = true;
      };
      ".config/waybar/script/ds4.sh" = {              # Custom script: Dualshock battery indicator
        text = ''
          #!/bin/sh

          FILE=/sys/class/power_supply/sony_controller_battery_e8:47:3a:05:c0:2b/capacity
          FILE2=/sys/class/power_supply/ps-controller-battery-e8:47:3a:05:c0:2b/capacity

          if [[ -f $FILE ]] then
            DS4BATT=$(cat $FILE)
            printf "<span font='13'>󰊴</span> $DS4BATT%%\n"
          elif [[ -f $FILE2 ]] then
            DS4BATT=$(cat $FILE2)
            printf "<span font='13'>󰊴</span> $DS4BATT%%\n"
          else
            printf "\n"
          fi

          exit 0
        '';
        executable = true;
      };
    };
  };
}
