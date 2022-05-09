{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;                  # Enable sway-session.target to link to graphical-session.target for systemd
    config = rec {                              # Sway configuration
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.dmenu}/bin/dmenu_run";
      startup = [{ 
        command = "${pkgs.autotiling}/bin/autotiling"; # Tiling Script
      }];                                       # Run commands on Sway startup
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";  # Starts waybar on Sway load
      }];
      fonts = {
        names = [ "Source Code Pro" ];
        size = 10.0;
      };
      gaps = {
        inner = 3;
        outer = 3;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
        };
      };
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+q" = "kill";
        "${modifier}+r" = "reload";
        "${modifier}+space" = "exec ${menu}";
        
        "${modifier}+Left" = "focus left";
        "${modifier}+Right" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Down" = "focus down";
        
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Down" = "move down";
 
        "alt+Left" = "workspace prev";
        "alt+Right" = "workspace next";

        "alt+1" = "workspace number 1";
        "alt+2" = "workspace number 2";
        "alt+3" = "workspace number 3";
        "alt+4" = "workspace number 4";
        "alt+5" = "workspace number 5";

        "alt+Shift+Left" = "move container to workspace prev, workspace prev";
        "alt+Shift+Right" = "move container to workspace next, workspace next";

        "alt+Shift+1" = "move container to workpace number 1";
        "alt+Shift+2" = "move container to workpace number 2";
        "alt+Shift+3" = "move container to workpace number 3";
        "alt+Shift+4" = "move container to workpace number 4";
        "alt+Shift+5" = "move container to workpace number 5";

        "Control+Up" = "resize shrink height 20px";
        "Control+Down" = "resize grow height 20px";
        "Control+Left" = "resize shrink width 20px";
        "Control+Right" = "resize grow width 20px";

        #"XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U  5";
        #"XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
      };
      };
    };
    extraConfig = ''
      output <display> {
        mode 1920x1080@60Hz
      }
    '';                                     # $ swaymsg -t get_outputs
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
