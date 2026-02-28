{
  inputs,
  ...
}:

{
  flake.modules.nixos.base =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/seti.yaml";
        cursor = {
          package = pkgs.capitaine-cursors;
          name = "capitaine-cursors";
          size = 16;
        };
        fonts = {
          serif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Serif";
          };

          sansSerif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Sans";
          };

          monospace = {
            package = pkgs.nerd-fonts.fira-code;
            name = "FiraCode Nerd Font Mono";
          };

          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };
        targets = {
          gnome.enable = false;
        };
      };

      home-manager.users.${config.host.user.name} = {
        stylix.targets = {
          gnome.enable = false;
        };
      };
    };
}
