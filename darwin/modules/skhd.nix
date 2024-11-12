#
#  Hotkey Daemon
#  Enable with "skhd.enable = true;"
#

{ config, lib, pkgs, vars, ... }:

with lib;
{
  options.skhd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Simple Hotkey Daemon for MacOS
      '';
    };
  };

  config = mkIf config.skhd.enable {
    services = {
      skhd = {
        enable = true;
        package = pkgs.skhd;
      };
    };

    home-manager.users.${vars.user} = {
      xdg.configFile."skhd/kill.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          window_pid=$(yabai -m query --windows --window | jq -r '.pid')
          count_pid=$(yabai -m query --windows | jq "[.[] | select(.pid == ''${window_pid})] | length")
          if [ "$count_pid" -gt 1 ]; then
            yabai -m window --close
          else
            kill "''${window_pid}"
          fi
        '';
      };
      xdg.configFile."skhd/skhdrc".text = ''
        # Open Applications
        alt - return : /Applications/kitty.app/Contents/MacOS/kitty ~
        alt - e : open ~

        # Toggle Window
        lalt - t : yabai -m window --toggle float && yabai -m window --grid 4:4:1:1:2:2
        lalt - f : yabai -m window --toggle zoom-fullscreen
        lalt - q : $HOME/.config/skhd/kill.sh

        # Focus Window
        lalt - up : yabai -m window --focus north || yabai -m display --focus north
        lalt - down : yabai -m window --focus south || yabai -m display --focus south
        lalt - left : yabai -m window --focus west || yabai -m display --focus west
        lalt - right : yabai -m window --focus east || yabai -m display --focus east

        # Swap Window
        alt + shift - left : yabai -m window --swap west  || $(yabai -m window --display west; yabai -m display --focus west)
        alt + shift - down : yabai -m window --swap south || $(yabai -m window --display south; yabai -m display --focus south)
        alt + shift - up : yabai -m window --swap north   || $(yabai -m window --display north; yabai -m display --focus north)
        alt + shift - right : yabai -m window --swap east || $(yabai -m window --display east; yabai -m display --focus east)

        # Resize Window
        cmd - left : yabai -m window --resize left:-50:0 && yabai -m window --resize right:-50:0
        cmd - right : yabai -m window --resize left:50:0 && yabai -m window --resize right:50:0
        cmd - up : yabai -m window --resize up:-50:0 && yabai -m window --resize down:-50:0
        cmd - down : yabai -m window --resize up:-50:0 && yabai -m window --resize down:-50:0

        # Focus Space
        ctrl + lalt - 1 : yabai -m space --focus 1
        ctrl + lalt - 2 : yabai -m space --focus 2
        ctrl + lalt - 3 : yabai -m space --focus 3
        ctrl + lalt - 4 : yabai -m space --focus 4
        ctrl + lalt - 5 : yabai -m space --focus 5
        ctrl + lalt - 6 : yabai -m space --focus 6
        ctrl + lalt - left : yabai -m space --focus prev
        ctrl + lalt - right: yabai -m space --focus next

        # Send to Space
        ctrl + shift + lalt - 1 : yabai -m window --space 1
        ctrl + shift + lalt - 2 : yabai -m window --space 2
        ctrl + shift + lalt - 3 : yabai -m window --space 3
        ctrl + shift + lalt - 4 : yabai -m window --space 4
        ctrl + shift + lalt - 5 : yabai -m window --space 5
        ctrl + shift + lalt - 6 : yabai -m window --space 6
        ctrl + shift + lalt - left : WIN_ID=$(yabai -m query --windows --window | jq '.id'); yabai -m window --space prev && yabai -m space --focus prev; yabai -m window --focus $WIN_ID;
        ctrl + shift + lalt - right : WIN_ID=$(yabai -m query --windows --window | jq '.id'); yabai -m window --space next && yabai -m space --focus next; yabai -m window --focus $WIN_ID;
      '';
      # fixes skhd not reloading after rebuild
      home.activation = {
        skhd-reloader = ''
          run skhd -r
        '';
      };
    };

    # required for key mapping to work
    system = {
      keyboard = {
        enableKeyMapping = true;
      };
    };
  };
}
