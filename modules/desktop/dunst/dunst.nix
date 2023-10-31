{ config, lib, pkgs, ... }:

{
  # …
  services.dunst = {
    enable = true;
    settings = {
      global = {
        browser = "${config.programs.firefox.package}/bin/firefox -new-tab";
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu";
        follow = "mouse";
        font = "JetBrainsMono Nerd Font";
        format = "<b>%s</b>\\n%b";
        frame_color = "#555555";
        frame_width = 5;
        geometry = "1000x10-5+30";
        horizontal_padding = 8;
        icon_position = "off";
        line_height = 0;
        markup = "full";
        padding = 8;
        separator_color = "frame";
        separator_height = 2;
        transparency = 10;
        word_wrap = true;
      };

      urgency_low = {
        background = "#1d1f21";
        foreground = "#4da1af";
        frame_color = "#4da1af";
        timeout = 10;
      };

      urgency_normal = {
        background = "#1d1f21";
        foreground = "#70a040";
        frame_color = "#70a040";
        timeout = 15;
      };

      urgency_critical = {
        background = "#1d1f21";
        foreground = "#dd5633";
        frame_color = "#dd5633";
        timeout = 0;
      };

      shortcuts = {
        context = "mod4+grave";
        close = "mod4+shift+space";
      };
    };
  };

  # …
}
