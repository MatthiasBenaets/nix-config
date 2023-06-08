{ config, lib, pkgs, ... }:

{
  services = {
    yabai = {                             # Tiling window manager
      enable = false;
      package = pkgs.yabai;
      config = {                          # Other configuration options
        layout = "bsp";
        auto_balance = "on";
        split_ratio = "0.50";
        window_border = "on";
        window_placement = "second_child";
        focus_follows_mouse = "off";
        mouse_follows_focus = "on";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        mouse_drop_action = "swap";
        top_padding = "10";
        bottom_padding = "10";
        left_padding = "10";
        right_padding = "10";
        window_gap = "10";
        external_bar = "all:28:0";
        insert_feedback_color = "0xffd75f5f";
        active_window_border_color = "0xffAFDCA4";
        normal_window_border_color = "0xffaaaaaa";
        active_window_border_topmost = "on";
        window_shadow = "on";
        window_opacity = "off";
        window_border_width = 5;
      };
      extraConfig = ''
        yabai -m rule --add app='^Emacs$' manage=on
        yabai -m rule --add title='Preferences' manage=off layer=above
        yabai -m rule --add title='NordPass Password Manager' manage=off layer=above
        yabai -m rule --add title='^(Opening)' manage=off layer=above
        yabai -m rule --add title='Library' manage=off layer=above
        yabai -m rule --add app='^System Preferences$' manage=off layer=above
        yabai -m rule --add app='Activity Monitor' manage=off layer=above
        yabai -m rule --add app='Finder' manage=off layer=above
        yabai -m rule --add app='^System Information$' manage=off layer=above
      '';                                 # Specific rules for what is managed and layered.
    };
  };
}
