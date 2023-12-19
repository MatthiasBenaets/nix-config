#
#  GTK
#

{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      file.".config/wall".source = ./wall;
      file.".config/wall.mp4".source = ./wall.mp4;
      pointerCursor = {                     # System-Wide Cursor
        gtk.enable = true;
        #name = "Dracula-cursors";
        name = "Catppuccin-Mocha-Dark-Cursors";
        #package = pkgs.dracula-theme;
        package = pkgs.catppuccin-cursors.mochaDark;
        size = 16;
      };
    };

    gtk = {                                 # Theming
      enable = true;
      theme = {
        #name = "Dracula";
        #name = "Catppuccin-Mocha-Compact-Blue-Dark";
        name = "Orchis-Dark-Compact";
        #package = pkgs.dracula-theme;
        # package = pkgs.catppuccin-gtk.override {
        #   accents = ["blue"];
        #   size = "compact";
        #   variant = "mocha";
        # };
        package = pkgs.orchis-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      font = {
        name = "FiraCode Nerd Font Mono Medium";
      };
    };

    qt.enable = true;
    qt.platformTheme = "gtk";
    qt.style.name = "adwaita-dark";
    qt.style.package = pkgs.adwaita-qt;
  };

  environment.variables = {
    QT_QPA_PLATFORMTHEME="gtk2";
  };
}
