#
#  Tiling Window Manager for MacOS
#  Enable with "yabai.enable = true;"
#

{ config, lib, pkgs, vars, ... }:

with lib;
{
  options.yabai = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Tiling Window Manager for MacOS
      '';
    };
  };

  config = mkIf config.yabai.enable {
    services = {
      yabai = {
        enable = true;
        # csrutils disable
        # sudo nvram boot-args=-arm64e_preview_abi
        enableScriptingAddition = true;
        package = pkgs.yabai;
      };
      jankyborders = {
        enable = true;
        active_color = "0xffa6a6a6";
        inactive_color = "0x00a6a6a6";
        style = "round";
        width = 5.0;
      };
    };

    homebrew = {
      casks = [
        "spaceid"
      ];
    };

    home-manager.users.${vars.user} = {
      # fixes yabai not reloading after rebuild (with scripting additions)
      home.activation = {
        yabai-reloader = ''
          run yabai --restart-service
          run sudo yabai --load-sa
        '';
      };

      xdg.configFile."yabai/yabairc".text = ''
        sudo yabai --load-sa
        yabai -m config auto_balance off
        yabai -m config bottom_padding 10
        yabai -m config layout bsp
        yabai -m config left_padding 10
        yabai -m config mouse_follows_focus off
        yabai -m config right_padding 10
        yabai -m config split_ratio 0.50
        yabai -m config top_padding 10
        yabai -m config window_border on
        yabai -m config window_border_width 2
        yabai -m config window_gap 10
        yabai -m config window_placement second_child


        yabai -m rule --add title='^(Opening)' manage=off
        yabai -m rule --add app="^System Settings$" manage=off
        yabai -m rule --add app="^Calculator$" manage=off
        yabai -m rule --add app="^App Store$" manage=off
        yabai -m rule --add app="^Calendar$" manage=off
        yabai -m rule --add app="^Finder$" manage=off
        yabai -m rule --add app="^Weather$" manage=off
      '';
    };
  };
}
