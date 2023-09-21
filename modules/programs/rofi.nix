#
#  System Menu
#

{ config, lib, pkgs, home-manager, vars, ... }:

let
  inherit (config.home-manager.users.${vars.user}.lib.formats.rasi) mkLiteral;
  colors = import ../theming/colors.nix;
in
{
  config = lib.mkIf (config.x11wm.enable) {
    home-manager.users.${vars.user} = {
        home = {
          packages = with pkgs; [
            rofi-power-menu
          ];
        };

        programs = {
          rofi = {
            enable = true;
            terminal = "${pkgs.${vars.terminal}}/bin/${vars.terminal}";
            location = "center";
            font = "FiraCode Nerd Font Mono 11";
            theme =  with colors.scheme.doom; {
              "*" = {
                bg0 = mkLiteral "#${bg}";
                bg1 = mkLiteral "#414868";
                fg0 = mkLiteral "#${text}";
                fg1 = mkLiteral "#${text-alt}";

                background-color = mkLiteral "transparent";
                text-color = mkLiteral "@fg0";

                margin = 0;
                padding = 0;
                spacing = 0;
              };

              "element-icon, element-text, scrollbar" = {
                cursor = mkLiteral "pointer";
              };

              "window" = {
                location = mkLiteral "northwest";
                width = mkLiteral "280px";
                x-offset = mkLiteral "8px";
                y-offset = mkLiteral "34px";

                background-color = mkLiteral "@bg0";
                border = mkLiteral "1px";
                border-color = mkLiteral "@bg1";
                border-radius = mkLiteral "6px";
              };

              "inputbar" = {
                spacing = mkLiteral "8px";
                padding = mkLiteral "4px 8px";
                children = mkLiteral "[ entry ]";
                background-color = mkLiteral "@bg0";
              };

              "entry, element-icon, element-text" = {
                vertical-align = mkLiteral "0.5";
              };

              "textbox" = {
                padding = mkLiteral "4px 8px";
                background-color = mkLiteral "@bg0";
              };

              "listview" = {
                padding = mkLiteral "4px 0px";
                lines = 6;
                columns = 1;
                scrollbar = true;
              };

              "element" = {
                padding = mkLiteral "4px 8px";
                spacing = mkLiteral "8px";
              };

              "element normal urgent" = {
                text-color = mkLiteral "@fg1";
              };

              "element normal active" = {
                text-color = mkLiteral "@fg1";
              };

              "element selected" = {
                text-color = mkLiteral "@bg0"; #1
                background-color = mkLiteral "@fg1";
              };

              "element selected urgent" = {
                background-color = mkLiteral "@fg1";
              };

              "element-icon" = {
                size = mkLiteral "0.8em";
              };

              "element-text" = {
                text-color = mkLiteral "inherit";
              };

              "scrollbar" = {
                handle-width = mkLiteral "4px";
                handle-color = mkLiteral "@fg1";
                padding = mkLiteral "0 4px";
              };
            };
          };
        };
      };
  };
}
