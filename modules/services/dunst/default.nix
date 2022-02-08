{ config, pkgs, ... }:

let
  colors = import ../../themes/helios.nix;
in
{
  xdg.dataFile."dbus-1/services/org.knopwob.dunst.service".source = "${pkgs.dunst}/share/dbus-1/services/org.knopwob.dunst.service";
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus Dark";
      package = pkgs.papirus-icon-theme;
      size = "16x16";
    };
    settings = with colors.scheme.helios; {
      global = {
        monitor = 0;
        # geometry [{width}x{height}][+/-{x}+/-{y}]
        # geometry = "600x50-50+65";
 	width = 300;
        height = 100;
        origin = "top-right";
        offset = "50x50";
        shrink = "yes";
        transparency = 10;
        padding = 16;
        horizontal_padding = 16;
        frame_width = 3;
        frame_color = "${base00}";
        separator_color = "frame";
        font = "FiraCode Nerd Font 10";
        line_height = 4;
        idle_threshold = 120;
        markup = "full";
        format = ''<b>%s</b>\n%b'';
        alignment = "left";
        vertical_alignment = "center";
        icon_position = "left";
        word_wrap = "yes";
        ignore_newline = "no";
        show_indicators = "yes";
        sort = true;
        stack_duplicates = true;
        # startup_notification = false;
        hide_duplicate_count = true;
      };
      urgency_low = {
        background = "#${base00}";
        foreground = "#${base05}";
        timeout = 4;
      };
      urgency_normal = {
        background = "#${base00}";
        foreground = "#${base05}";
        timeout = 4;
      };
      urgency_critical = {
        background = "#${base0A}";
        foreground = "#${base0D}";
        frame_color = "#${base08}";
        timeout = 10;
      };
    };
  };
}
