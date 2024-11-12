#
#  Tiling Window Manager for MacOS
#  Enable with "yabai.enable = true;"
#

{ config, lib, pkgs, ... }:

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
        config = {
          layout = "bsp";
          auto_balance = "off";
          split_ratio = "0.50";
          window_border = "on";
          window_border_width = "2";
          window_placement = "second_child";
          # focus_follows_mouse = "autoraise";
          mouse_follows_focus = "off";
          top_padding = "10";
          bottom_padding = "10";
          left_padding = "10";
          right_padding = "10";
          window_gap = "10";
        };
        extraConfig = ''
          sudo yabai --load-sa

          yabai -m rule --add title='^(Opening)' manage=off
          yabai -m rule --add app="^System Settings$" manage=off
          yabai -m rule --add app="^Calculator$" manage=off
          yabai -m rule --add app="^App Store$" manage=off
          yabai -m rule --add app="^Calendar$" manage=off
          yabai -m rule --add app="^Finder$" manage=off
          yabai -m rule --add app="^Weather$" manage=off
        '';
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
  };
}
