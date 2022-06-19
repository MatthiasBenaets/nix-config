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
        #battery,
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
        #battery {
          color: #9ece6a;
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
        #modules-left = [ "sway/workspaces" "sway/window" "sway/mode" ];
        modules-left = [ "wlr/workspaces" ];
        modules-right = [ "cpu" "memory" "disk" "pulseaudio" "battery" "network" "tray" ];

        "gtk-layer-shell" = false;
        "sway/workspaces" = {
          format = "<span font='14'>{icon}</span>";
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
          format = "<span font='14'>{icon}</span>";
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
          format = "{:%b %d %H:%M} <span font='14'></span>";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%A, %B %d, %Y} ";
        };
        cpu = {
          format = "{usage}% <span font='14'></span>";
          tooltip = false;
          interval = 1;
        };
        disk = {
          format = "{percentage_used}% <span font='14'></span>";
          path = "/";
          interval = 30;
        };
        memory = {
          format = "{}% <span font='14'></span>";
          interval = 1;
        };
        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% <span font='16'>{icon}</span>";
          format-charging = "{capacity}% <span font='14'></span>";
          format-icons = ["" "" "" "" ""];
          max-length = 25;
        };
        network = {
          format-wifi = "<span font='14'></span>";
          format-ethernet = "<span font='14'></span> {ifname}: {ipaddr}/{cidr}";
          format-linked = "<span font='14'>睊</span> {ifname} (No IP)";
          format-disconnected = "<span font='14'>睊</span> Not connected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{essid} {signalStrength}%";
          on-click-right = "${pkgs.alacritty}/bin/alacritty -e nmtui";
        };
        pulseaudio = {
          format = "<span font='14'>{icon}</span> {volume}% {format_source}";
          format-bluetooth = "<span font='14'>{icon}</span> {volume}% {format_source}";
          format-bluetooth-muted = "<span font='14'></span> {volume}% {format_source}";
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
          on-click = "${pkgs.pamixer}/bin/pamixer -t";
          on-click-right = "${pkgs.pamixer}/bin/pamixer --default-source -t";
          on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        tray = {
          icon-size = 14;
        };
      }];
    };
  };
}
