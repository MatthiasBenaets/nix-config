{
  flake.modules.homeManager.kitty =
    {
      lib,
      pkgs,
      config,
      osConfig ? null,
      ...
    }:
    {
      programs = {
        kitty = {
          enable = true;
          settings = {
            confirm_os_window_close = 0;
            enable_audio_bell = "no";
            resize_debounce_time = 0;
            shell = "${pkgs.zsh}/bin/zsh";
            background_opacity = lib.mkForce "0.8";
            background_blur = 16;
          };
        };
      };
    };

  flake.modules.darwin.kitty =
    { config, ... }:
    {
      homebrew = {
        enable = true;
        casks = [
          "kitty"
          "font-meslo-lg-nerd-font"
          "font-fira-code-nerd-font"
        ];
      };

      home-manager.users.${config.host.user.name} = {
        home.file = {
          ".ssh/config" = {
            text = ''
              Host *
                UseKeychain yes
                AddKeysToAgent yes
                SetEnv TERM=xterm-256color
            '';
          };
          ".config/kitty/kitty.conf" = {
            text = ''
              font_family FiraCode Nerd Font Mono
              font_size 13

              # background_opacity 0.8
              # background_blur 16

              window_margin_width 4
              single_window_margin_width 0

              hide_window_decorations titlebar-only

              tab_bar_style powerline
              tab_powerline_style slanted

              confirm_os_window_close 0


              # Tokyonight
              foreground #a9b1d6
              background #1a1b26

              # Black
              color0 #414868
              color8 #414868

              # Red
              color1 #f7768e
              color9 #f7768e

              # Green
              color2  #73daca
              color10 #73daca

              # Yellow
              color3  #e0af68
              color11 #e0af68

              # Blue
              color4  #7aa2f7
              color12 #7aa2f7

              # Magenta
              color5  #bb9af7
              color13 #bb9af7

              # Cyan
              color6  #7dcfff
              color14 #7dcfff

              # White
              color7  #c0caf5
              color15 #c0caf5

              # Cursor
              cursor #c0caf5
              cursor_text_color #1a1b26

              # Selection highlight
              selection_foreground none
              selection_background #28344a

              # The color for highlighting URLs on mouse-over
              url_color #9ece6a

              # Window borders
              active_border_color #3d59a1
              inactive_border_color #101014
              bell_border_color #e0af68

              # Tab bar
              tab_bar_style fade
              tab_fade 1
              active_tab_foreground   #3d59a1
              active_tab_background   #16161e
              active_tab_font_style   bold
              inactive_tab_foreground #787c99
              inactive_tab_background #16161e
              inactive_tab_font_style bold
              tab_bar_background #101014

              # Title bar
              macos_titlebar_color #16161e

              map ctrl+space no_op
              map cmd+f no_op

              map f1 new_window_with_cwd
              map cmd+t new_tab_with_cwd
              startup_session ~/.config/kitty/startup.conf

              shell_integration no-sudo
            '';
          };
        };
      };
    };
}
