{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;
  rofi-theme = {    
        "*" = {
          bg = mkLiteral "#11121D";
          bg-alt = mkLiteral "#444b6a";

          fg = mkLiteral "#FFFFFF";
          fg-alt = mkLiteral "#787c99";

          background-color = mkLiteral "#11121D";

          border = 0;
          margin = 0;
          padding = 0;
          spacing = 0;
        };

        "window" = {
          width = mkLiteral "30%";
        };

        "element" = {
          padding = mkLiteral "8 0";
          text-color = mkLiteral "#787c99";
        };

        "element selected" = {
          text-color = mkLiteral "#FFFFFF";
        };

        "element-text" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
        };

        "element-icon" = {
          size = 30;
        };

        "entry" = {
          background-color = mkLiteral "#787c98";
          padding = 12;
          text-color = mkLiteral "#FFFFFF";
        };
        
        "inputbar" = {
          children = mkLiteral "[prompt, entry]";
        };

        "listview" = {
          padding = mkLiteral "8 12";
          background-color = mkLiteral "#11121d";
          columns = 1;
          lines = 8;
        };

        "mainbox" = {
          background-color = mkLiteral "#11121d";
          children = mkLiteral "[inputbar, listview]";
        };

        "prompt" = {
          background-color = mkLiteral "#444b6a";
          enabled = true;
          padding = mkLiteral "12 0 0 12";
          text-color = mkLiteral "#FFFFFF";
        };
     };
in
{
  programs = {
    rofi = { 
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      location = "center"; 
      theme = rofi-theme; 
    };
  };
}
