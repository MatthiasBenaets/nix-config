{ config, lib, pkgs, ... }:

let                                         # Variables
  modifier = "Mod4";
in
{
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;              # Enable sway-session.target to link to graphical-session.target for systemd
    config = {
      keybindings = {
        "${modifier}+Return" = "exec ${pkgs.foot}/bin/foot";
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
