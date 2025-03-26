#
#  Terminal Emulator
#

{ vars, ... }:

{
  homebrew.casks = [
    "kitty"
    "font-meslo-lg-nerd-font" # MesloLGS Nerd Font Mono
    "font-fira-code-nerd-font" # FiraCode Nerd Font Mono
  ];

  home-manager.users.${vars.user} = {
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

          background_opacity 0.8
          background_blur 16

          window_margin_width 4
          single_window_margin_width 0
          active_border_color   #d0d0d0
          inactive_border_color #202020

          hide_window_decorations titlebar-only

          tab_bar_style powerline
          tab_powerline_style slanted

          confirm_os_window_close 0

          background            #202020
          foreground            #d0d0d0
          cursor                #d0d0d0
          selection_background  #303030
          color0                #151515
          color8                #505050
          color1                #ac4142
          color9                #ac4142
          color2                #7e8d50
          color10               #7e8d50
          color3                #e5b566
          color11               #e5b566
          color4                #6c99ba
          color12               #6c99ba
          color5                #9e4e85
          color13               #9e4e85
          color6                #7dd5cf
          color14               #7dd5cf
          color7                #d0d0d0
          color15               #f5f5f5
          selection_foreground  #202020

          map f1 new_window_with_cwd
          map cmd+t new_tab_with_cwd
          startup_session ~/.config/kitty/startup.conf

          shell_integration no-sudo
        '';
      };
    };
  };
}
