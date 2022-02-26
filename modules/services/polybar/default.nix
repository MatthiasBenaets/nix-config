#
# Bar
#

{ pkgs, ... }:

let
  mypolybar = pkgs.polybar.override {           # Extra packages to run polybar (mostly sound atm)
    alsaSupport = true;
    pulseSupport = true;
  };
in
{ 
  home.file.".config/polybar/script/mic.sh" ={
    source = ./mic.sh;
    executable = true;
  };
  services = {
    polybar = {
      enable = true;
      script = ''                               # Running polybar on startup
        #!/bin/sh
        killall -q polybar

        while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

        polybar main &                          # Does some issues with the workspaces not loading

        if [[ $(xrandr -q | grep 'HDMI-A-0 connected') ]]; then
          polybar sec &
        fi
      '';                                       # Gets fixed in the bspwmrc file
      package = mypolybar;
      config = {
        "bar/main" = {                          # Bar name = Top
          #monitor = "HDMI-A-1";
          width = "100%";
          height = 15;
          background = "#00000000";
          foreground = "#ccffffff";

          offset-y = 2;
          spacing = "1.5";
          padding-right = 2;

          module-margin-left = 1;
          #module-margin-right = "0.5";

          font-0 = "SourceCodePro:size=10";     # Icons
          font-1 = "FontAwesome5Free:style=Solid:size=8";
          font-2 = "FontAwesome5Free:style=Regular:size=8";
          font-3 = "FontAwesome5Brands:style=Regular:size=8";
          font-4 = "FiraCodeNerdFont:size=11"; 
          modules-left = "logo bspwm";
          modules-right = "backlight pad memory cpu pad mic volume pad battery pad date"; #wired-network wireless-network bluetooth";
         
          tray-position = "right";
          tray-detached = "false";
        };
        "bar/sec" = {
          monitor = "HDMI-A-0";
          width = "100%";
          height = 15;
          background = "#00000000";
          foreground = "#ccffffff";

          offset-y = 2;
          spacing = "1.5";
          padding-right = 2;
          module-margin-left = 1;
          #module-margin-right = "0.5";

          font-0 = "SourceCodePro:size=10";     # Icons
          font-1 = "FontAwesome5Free:style=Solid:size=8";
          font-2 = "FontAwesome5Free:style=Regular:size=8";
          font-3 = "FontAwesome5Brands:style=Regular:size=8";
          font-4 = "FiraCodeNerdFont:size=11";
          modules-left = "logo bspwm";
          #modules-right = "bspwm";
        };
        "module/memory" = {                     # RAM
          type = "internal/memory";
          format = "<label>"; #<bar-used>";
          format-foreground = "#999";
          label = "  %percentage_used%%";

#         bar-used-width = 30;                  # Add visual usage
#         bar-used-foreground-0 = "#aaff77";
#         bar-used-foreground-1 = "#aaff77";
#         bar-used-foreground-2 = "#fba922";
#         bar-used-foreground-3 = "#ff5555";
#         bar-used-indicator = "|";
#         bar-used-indicator-font = 6;
#         bar-used-indicator-foreground = "#fff";
#         bar-used-fill = "─";
#         bar-used-fill-font = 6;
#         bar-used-empty = "─";
#         bar-used-empty-font = 6;
#         bar-used-empty-foreground = "#444444";
        };
        "module/cpu" = {                        # CPU
          type = "internal/cpu";
          interval = 1;
          format = "<label>"; # <ramp-coreload>";
          format-foreground = "#999";
          label = "  %percentage%%";

#         ramp-coreload-0 = "▁";                # Add visual usage
#         ramp-coreload-0-font = 2;
#         ramp-coreload-0-foreground = "#aaff77";
#         ramp-coreload-1 = "▂";
#         ramp-coreload-1-font = 2;
#         ramp-coreload-1-foreground = "#aaff77";
#         ramp-coreload-2 = "▃";
#         ramp-coreload-2-font = 2;
#         ramp-coreload-2-foreground = "#aaff77";
#         ramp-coreload-3 = "▄";
#         ramp-coreload-3-font = 2;
#         ramp-coreload-3-foreground = "#aaff77";
#         ramp-coreload-4 = "▅";
#         ramp-coreload-4-font = 2;
#         ramp-coreload-4-foreground = "#fba922";
#         ramp-coreload-5 = "▆";
#         ramp-coreload-5-font = 2;
#         ramp-coreload-5-foreground = "#fba922";
#         ramp-coreload-6 = "▇";
#         ramp-coreload-6-font = 2;
#         ramp-coreload-6-foreground = "#ff5555";
#         ramp-coreload-7 = "█";
#         ramp-coreload-7-font = 2;
#         ramp-coreload-7-foreground = "#ff5555";
        };
        "module/volume" = {                     # Volume
          type = "internal/pulseaudio";
          interval = 2;
          use-ui-max = "false";
          format-volume = "<ramp-volume> <label-volume>";
          label-muted = "  muted";
          label-muted-foreground = "#66";

          ramp-volume-0 = "";
          ramp-volume-1 = "";
          ramp-volume-2 = "";

          click-right = "${pkgs.pavucontrol}/bin/pavucontrol";  # Right click opens pavucontrol, left click mutes, scroll changes levels
        };
        "module/backlight" = {                  # Keeping for the futur when i have a screen that supports xbacklight
          type = "internal/backlight";          # Now doen with sxhkb shortcuts
          card = "intel_backlight";
          #use-actual-brightness = "false";
          format = "<ramp> <bar>";
 
          ramp-0 = "";
          ramp-1 = "";
          ramp-2 = "";
 
          bar-width = 10;
          bar-indicator = "|";
          bar-indicator-font = 3;
          bar-indicator-foreground = "#ff";
          bar-fill = "─";
          bar-fill-font = 3;
          bar-fill-foreground = "ff"; #"#c9665e";
          bar-empty = "─";
          bar-empty-font = 3;
          bar-empty-foreground = "#44";
        };
#       "module/wireless-network" = {           # Show either wired or wireless
#         type = "internal/network";
#         interface = "wlo1";
#         interval = "3.0";
#         ping-interval = 10;
#
##        format-connected = "<ramp-signal>";
#         format-connected = "<ramp-signal> <label-connected>";
#         label-connected = "%essid%";
#         label-disconnected = "";
#         label-disconnected-foreground = "#66";
#
#         ramp-signal-0 = "";
#
#         animation-packetloss-0 = "";
#         animation-packetloss-0-foreground = "#ffa64c";
#         animation-packetloss-1 = "";
#         animation-packetloss-1-foreground = "#00000000";
#         animation-packetloss-framerate = 500;
#       };
#       "module/wired-network" = {              # Ditto module above
#         type = "internal/network";
#         interface = "enp0s25";
#         interval = "3.0";
#
#         label-connected = "  %{T3}%local_ip%%{T-}";
##        label-connected = "";
#         label-disconnected-foreground = "#66";
#       };
        "module/battery" = {                    # Show battery (only when exist), uncomment to show battery and animations
          type = "internal/battery";
          full-at = 98;

          label-full = "%percentage%%";
          label-charging = "%percentage%%";
          label-discharging = "%percentage%%";

          format-charging = "<animation-charging> <label-charging>";
          format-discharging = "<ramp-capacity> <label-discharging>";
          format-full = "<ramp-capacity> <label-full>";
 
          ramp-capacity-0 = "";
          ramp-capacity-0-foreground = "#f53c3c";
          ramp-capacity-1 = "";
          ramp-capacity-1-foreground = "#ffa900";
          ramp-capacity-2 = "";
          ramp-capacity-3 = "";
          ramp-capacity-4 = "";
 
          bar-capacity-width = 10;
          bar-capacity-format = "%{+u}%{+o}%fill%%empty%%{-u}%{-o}";
          bar-capacity-fill = "█";
          bar-capacity-fill-foreground = "#ddffffff";
          bar-capacity-fill-font = 3;
          bar-capacity-empty = "█";
          bar-capacity-empty-font = 3;
          bar-capacity-empty-foreground = "#44ffffff";
 
          animation-charging-0 = "";          # Animation when charging
          animation-charging-1 = "";
          animation-charging-2 = "";
          animation-charging-3 = "";
          animation-charging-4 = "";
          animation-charging-framerate = 750;
        };
        "module/date" = {                       # Time/Date  Day-Month-Year Hour:Minute
          type = "internal/date";
          date = "  %%{F#999}%d-%m-%Y%%{F-} %%{F#fff}%H:%M%%{F-}";
        };
        "module/bspwm" = {                      # Workspaces
          type = "internal/bspwm";
          pin-workspace = true;
          #label-monitor = "%name%";

          ws-icon-0 = "1;";                    # Needs to be the same amount and same name as bswmrc
          ws-icon-1 = "2;";
          ws-icon-2 = "3;";
          ws-icon-3 = "4;";
          ws-icon-4 = "5;";
          ws-icon-5 = "6;";
          ws-icon-6 = "7;";
          ws-icon-7 = "8;";
          ws-icon-8 = "9;";
          ws-icon-9 = "0;";
          #ws-icon-default = "";               # Can have more workspaces availabe but enable default icon

          format = "<label-state> <label-mode>";

          label-dimmed-underline = "#ccffffff"; # Colors in use, active or inactive

          label-focused = "%icon%";
          label-focused-foreground = "#fff";
          label-focused-background = "#773f3f3f";
          label-focused-underline = "#c9665e";
          label-focused-font = 4;
          label-focused-padding = 2;

          label-occupied = "%icon%";
          label-occupied-foreground = "#ddd";
          label-occupied-underline = "#666";
          label-occupied-font = 4;
          label-occupied-padding = 2;

          label-urgent = "%icon%";
          label-urgent-foreground = "#000000";
          label-urgent-background = "#bd2c40";
          label-urgent-underline = "#9b0a20";
          label-urgent-font = 4;
          label-urgent-padding = 2;

          label-empty = "%icon%";
          label-empty-foreground = "#55";
          label-empty-font = 4;
          label-empty-padding = 2;

          label-monocle = "M";
          label-monocle-underline = "#c9665e";
          label-monocle-background = "#33ffffff";
          label-monocle-padding = 2;

          label-locked = "L";
          label-locked-foreground = "#bd2c40";
          label-locked-underline = "#c9665e";
          label-locked-padding = 2;

          label-sticky = "S";
          label-sticky-foreground = "#fba922";
          label-sticky-underline = "#c9665e";
          label-sticky-padding = 2;

          label-private = "P";
          label-private-foreground = "#bd2c40";
          label-private-underline = "#c9665e";
          label-private-padding = 2;
        };
       "module/title" = {                      # Show title of active screen
          type = "internal/xwindow";
          format = "<label>";
          format-background = "#00000000";
          format-foreground = "#ccffffff";
          label = "%title%";
          label-maxlen = 75;
          label-empty = "";
          label-empty-foreground = "#ccffffff";
        };
        
        # CUSTOM
        "module/pad" = {
          type = "custom/text";
          content = "    ";
        };
        "module/mic" = {
          type = "custom/script";
          interval = 1;
          tail = "true";
          exec = "~/.config/polybar/script/mic.sh status";
#          click-left = "pactl list sources | grep -qi 'Mute: yes' && pactl set-source-mute 1 false || pactl set-source-mute 1 true ";
          click-left = "~/.config/polybar/script/mic.sh toggle";
        };
        "module/logo" = {
          type = "custom/text";
          content = " %{F#a7c7e7} ";
          format-foreground = "#a7c7e7";
          click-right = "bspc quit";
        };
        "module/bluetooth" = {
          type = "custom/text";
          content = "";
          click-left = "${pkgs.blueman}/bin/blueman-manager";
        };
      };
    };
  };
}


