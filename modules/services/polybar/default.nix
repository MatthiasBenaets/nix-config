{ pkgs, ... }:

let
  mypolybar = pkgs.polybar.override {
    alsaSupport = true;
    pulseSupport = true;
  };
in
{
  services = {
    polybar = {
      enable = true;
      script = ''
        killall -q polybar
        while pgrep -x polybar >/dev/null; do sleep 1; done
        sleep 1; polybar top 2>~/log &
      '';
      package = mypolybar;
      config = {
        "bar/top" = {
          width = "100%";
          height = 18;
          background = "#00000000";
          foreground = "#ccffffff";

          spacing = 2;
          padding-right = 5;

          #module-margin = 2;
          module-margin-left = 5;
          module-margin-right = 5;

          font-0 = "SourceCodePro:size=9";
          font-1 = "Fira Code Nerd Font:size=10";
          modules-left = "bspwm";
          modules-right = "volume date";
        };
        "module/volume" = {  
          type = "internal/pulseaudio";
          interval = 2;
          use-ui-max = "false";
          format-volume = "<ramp-volume> <label-volume>";
          label-muted = " muted";
          label-muted-foreground = "#66";

          ramp-volume-0 = "";
          ramp-volume-1 = "";
          ramp-volume-2 = "";

          click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        "module/date" = {
          type = "internal/date";
          date = "  %%{F#999}%d-%m-%Y%%{F-} %%{F#fff}%H:%M%%{F-}"; 
        };
        "module/bspwm" = {
          type = "internal/bspwm";
          ws-icon-0 = "I;";
          ws-icon-1 = "II;";
          ws-icon-2 = "III;";
          ws-icon-3 = "IV;";
          ws-icon-4 = "V;";
          #ws-icon-default = "";
  
          format = "<label-state> <label-mode>";
 
          label-dimmed-underline = "#ccffffff";
 
          label-active = "%icon%";
          label-active-foreground = "#fff";
          label-active-background = "#773f3f3f";
          label-active-underline = "#c9665e";
          label-active-font = 4;
          label-active-padding = 4;
 
          label-occupied = "%icon%";
          label-occupied-foreground = "#ddd";
          label-occupied-underline = "#666";
          label-occupied-font = 4;
          label-occupied-padding = 4;
 
          label-urgent = "%icon%";
          label-urgent-foreground = "#000000";
          label-urgent-background = "#bd2c40";
          label-urgent-underline = "#9b0a20";
          label-urgent-font = 4;
          label-urgent-padding = 4;
 
          label-empty = "%icon%";
          label-empty-foreground = "#55";
          label-empty-font = 4;
          label-empty-padding = 4;
 
          label-monocle = "1";
          label-monocle-underline = "#c9665e";
          label-monocle-background = "#33ffffff";
          label-monocle-padding = 2;
 
          label-locked = "2";
          label-locked-foreground = "#bd2c40";
          label-locked-underline = "#c9665e";
          label-locked-padding = 2;
 
          label-sticky = "3";
          label-sticky-foreground = "#fba922";
          label-sticky-underline = "#c9665e";
          label-sticky-padding = 2;
  
          label-private = "4";
          label-private-foreground = "#bd2c40";
          label-private-underline = "#c9665e";
          label-private-padding = 2;
        };
      };
    };
  };
}
