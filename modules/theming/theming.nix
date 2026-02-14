#
#  GTK
#

{ lib, config, pkgs, host, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      file.".config/wall.png".source = ./wall.png;
      file.".config/wall.mp4".source = ./wall.mp4;
      pointerCursor = {
        gtk.enable = true;
        name = "Dracula-cursors";
        package = pkgs.dracula-theme;
        size = 16;
      };
    };

    gtk = lib.mkIf (config.gnome.enable == false) {
      enable = true;
      theme = {
        #name = "Dracula";
        #name = "Catppuccin-Mocha-Compact-Blue-Dark";
        # name = "Orchis-Dark-Compact";
        name = "adw-gtk3-dark";
        #package = pkgs.dracula-theme;
        # package = pkgs.catppuccin-gtk.override {
        #   accents = ["blue"];
        #   size = "compact";
        #   variant = "mocha";
        # };
        # package = pkgs.orchis-theme;
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      font = {
        # name = "FiraCode Nerd Font Mono Medium";
        name = "Noto Sans";
      };
    };

    # qt = {
    #   enable = true;
    #   platformTheme.name = "gtk";
    #   style = {
    #     name = "adwaita-dark";
    #     package = pkgs.adwaita-qt;
    #   };
    # };
  };

  # environment.variables = {
  #   QT_QPA_PLATFORMTHEME = "gtk2";
  # };
}
