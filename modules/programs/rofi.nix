#
# System Menu
#

{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;        # Theme.rasi alternative. Add Theme here
  colors = import ../themes/colors.nix;
in
{
  programs = {
    rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";           # Alacritty is default terminal emulator
      location = "center";
      theme =  with colors.scheme.doom; {
        "*" = {
          spacing = 0;
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "#${text}";
        };

        "window" = {
          transparency = "real";
          fullscreen = true;
          background-color = mkLiteral "#${bg}";
        };

        "mainbox" = {
          padding = mkLiteral "30% 30%";
        };

        "inputbar" = {
          margin = mkLiteral "0px 0px 20px 0px";
          children = mkLiteral "[prompt, textbox-prompt-colon, entry, case-indicator]";
        };

        "prompt" = {
          text-color = mkLiteral "#${blue}";
        };

        "textbox-prompt-colon" = {
          expand = false;
          str = ":";
          text-color = mkLiteral "#${text-alt}";
        };

        "entry" = {
          margin = mkLiteral "0px 10px";
        };

        "listview" = {
          spacing = mkLiteral "5px";
          dynamic = true;
          scrollbar = false;
        };

        "element" = {
          padding = mkLiteral "5px";
          text-color = mkLiteral "#${text-alt}";
          highlight = mkLiteral "bold #${green}";
          border-radius = mkLiteral "3px";
        };

        "element selected" = {
          background-color = mkLiteral "#${emphasis}";
          text-color = mkLiteral "#${text}";
        };

        "element urgent, element selected urgent" = {
          text-color = mkLiteral "#${red}";
        };

        "element active, element selected active" = {
          text-color = mkLiteral "#${magenta}";
        };

        "message" = {
          padding = mkLiteral "5px";
          border-radius = mkLiteral "3px";
          background-color = mkLiteral "#${emphasis}";
          border = mkLiteral "1px";
          border-color = mkLiteral "#${cyan}";
        };

        "button selected" = {
          padding = mkLiteral "5px";
          border-radius = mkLiteral "3px";
          background-color = mkLiteral "#${emphasis}";
        };
      };
    };
  };
}
