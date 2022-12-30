#
# Bar
#

{ config, lib, pkgs, host, ...}:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  nixpkgs.overlays = [                                      # Waybar needs to be compiled with the experimental flag for wlr/workspaces to work
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        patchPhase = ''
          substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
        '';
      });
    })
  ];

  home-manager.users.matthias = {                           # Home-manager waybar config
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
        #battery,
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
        }
        #battery.critical {
          color: #ff200c;
        }
        #battery.charging {
          color: #9ece6a;
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
          modules-right = [ "network" "cpu" "memory" "custom/pad" "pulseaudio" "custom/sink" "custom/pad" "clock" "tray" ];

          "custom/pad" = {
            format = "      ";
            tooltip = false;
          };
          "custom/menu" = {
            format = "<span font='16'></span>";
            on-click = "${pkgs.rofi}/bin/rofi -show p -modi p:${pkgs.rofi-power-menu}/bin/rofi-power-menu -theme $HOME/.config/rofi/config.rasi";
            on-click-right = "${pkgs.rofi}/bin/rofi -show drun";
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
            format-muted = "<span font='11'>x</span> {format_source} ";
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
            format = "<span font='9'>蓼</span>";
            on-click = "$HOME/.config/waybar/script/sink.sh";
            tooltip = false;
          };
          tray = {
            icon-size = 13;
          };
        };
        Sec = if ( hostName == "desktop" ) then {
          layer = "top";
          position = "top";
          height = 16;
          output = [
            "${secondMonitor}"
          ];
          modules-left = [ "custom/menu" "wlr/workspaces" ];
          modules-right = [ "pulseaudio" "custom/sink" "custom/pad" "clock"];

          "custom/pad" = {
            format = "      ";
            tooltip = false;
          };
          "custom/menu" = {
            format = "<span font='16'></span>";
            on-click = "${pkgs.rofi}/bin/rofi -show p -modi p:${pkgs.rofi-power-menu}/bin/rofi-power-menu -theme $HOME/.config/rofi/config.rasi";
            on-click-right = "${pkgs.rofi}/bin/rofi -show drun";
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
          pulseaudio = {
            format = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth-muted = "<span font='11'></span> {volume}% {format_source} ";
            format-muted = "<span font='11'></span> {format_source} ";
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
            format = "<span font='10'>蓼</span>";
            on-click = "$HOME/.config/waybar/script/sink.sh";
            tooltip = false;
          };
        } else {};
      };
    };
    home.file.".config/waybar/script/sink.sh" = {              # Custom script: Toggle speaker/headset
      text = ''
        #!/bin/sh

        ID1=$(awk '/ Built-in Audio Analog Stereo/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | head -n 1)
        ID2=$(awk '/ S10 Bluetooth Speaker/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | sed -n 2p)

        HEAD=$(awk '/ Built-in Audio Analog Stereo/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | sed -n 2p)
        SPEAK=$(awk '/ S10 Bluetooth Speaker/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)

        if [[ $HEAD = "*" ]]; then
          ${pkgs.wireplumber}/bin/wpctl set-default $ID2
          echo -e "{\"text\":\""蓼"\"}"
        elif [[ $SPEAK = "*" ]]; then
          ${pkgs.wireplumber}/bin/wpctl set-default $ID1
          echo -e "{\"text\":\"""\"}"
        fi
      '';
      executable = true;
    };
  };
}
