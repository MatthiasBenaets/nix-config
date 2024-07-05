#
#  Terminal Configuration
#

{ vars, ... }:

{
  homebrew.casks = [
    "alacritty"
    "font-meslo-lg-nerd-font"
  ];

  home-manager.users.${vars.user} = {
    home.file = {
      ".config/alacritty/alacritty.toml" = {
        text = ''
          [env]
          TERM = "xterm-256color"

          [window]
          padding.x = 10
          padding.y = 10

          decorations = "Buttonless"

          opacity = 0.85
          blur = true

          option_as_alt = "Both"

          [font]
          normal.family = "MesloLGS Nerd Font Mono"

          size=13

          # Default colors
          [colors.primary]
          background = '#2c2c2c'
          foreground = '#d6d6d6'

          dim_foreground    = '#dbdbdb'
          bright_foreground = '#d9d9d9'

          # Cursor colors
          [colors.cursor]
          text   = '#2c2c2c'
          cursor = '#d9d9d9'

          # Normal colors
          [colors.normal]
          black   = '#1c1c1c'
          red     = '#bc5653'
          green   = '#909d63'
          yellow  = '#ebc17a'
          blue    = '#7eaac7'
          magenta = '#aa6292'
          cyan    = '#86d3ce'
          white   = '#cacaca'

          # Bright colors
          [colors.bright]
          black   = '#636363'
          red     = '#bc5653'
          green   = '#909d63'
          yellow  = '#ebc17a'
          blue    = '#7eaac7'
          magenta = '#aa6292'
          cyan    = '#86d3ce'
          white   = '#f7f7f7'

          # Dim colors
          [colors.dim]
          black   = '#232323'
          red     = '#74423f'
          green   = '#5e6547'
          yellow  = '#8b7653'
          blue    = '#556b79'
          magenta = '#6e4962'
          cyan    = '#5c8482'
          white   = '#828282'
        '';
      };
    };
  };
}
