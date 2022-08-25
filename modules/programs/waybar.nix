#
# Bar
#

{ config, lib, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  nixpkgs.overlays = [                                      # Waybar needs to be compiled with the experimental flag for wlr/workspaces to work
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
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
          font-weight: bold;
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
          margin: 2px 16px 2px 16px;
          background-clip: padding-box;
        }
        #workspaces button {
          padding: 0 5px;
          min-width: 15px;
        }
        #workspaces button:hover {
          background-color: rgba(0,0,0,0.2);
        }
        #workspaces button.focused {
          color: #ccffff;
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
      settings = [{
        layer = "top";
        position = "top";
        height = 16;
        output = [
          #"eDP-1"
          "DP-2"
          "HDMI-A-2"
        ];
        tray = { spacing = 10; };
        #modules-center = [ "clock" ];
        #modules-left = [ "sway/workspaces" "sway/window" "sway/mode" ];
        #modules-left = [ "wlr/workspaces" ];
        #modules-right = [ "cpu" "memory" "disk" "pulseaudio" "battery" "network" "tray" ];
        modules-right = [ "cpu" "memory" "pulseaudio" "clock" "tray" ];

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
          format = "<span font='12'>{icon}</span>";
          format-icons = {
            "1"="";
            "2"="";
            "3"="";
            "4"="";
            "5"="";
          };
          all-outputs = true;
          active-only = false;
          on-click = "activate";
        };
        clock = {
          format = "{:%b %d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%A, %B %d, %Y} ";
        };
        cpu = {
          format = "{usage}% <span font='11'></span>";
          tooltip = false;
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
          format-ethernet = "<span font='11'></span> {ifname}: {ipaddr}/{cidr}";
          format-linked = "<span font='11'>睊</span> {ifname} (No IP)";
          format-disconnected = "<span font='11'>睊</span> Not connected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{essid} {signalStrength}%";
          on-click-right = "${pkgs.alacritty}/bin/alacritty -e nmtui";
        };
        pulseaudio = {
          format = "<span font='11'>{icon}</span> {volume}% {format_source}";
          format-bluetooth = "<span font='11'>{icon}</span> {volume}% {format_source}";
          format-bluetooth-muted = "<span font='11'></span> {volume}% {format_source}";
          format-muted = "<span font='11'></span> {format_source}";
          #format-source = "{volume}% <span font='11'></span>";
          format-source = "<span font='11'></span>";
          format-source-muted = "<span font='11'></span>";
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
        tray = {
          icon-size = 11;
        };
      }];
    };
  };
}
