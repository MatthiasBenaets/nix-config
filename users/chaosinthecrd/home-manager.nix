{ lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

in {

  xdg.enable = true;

  gtk = {
    enable = true;
    cursorTheme = {
      name = "macOS-BigSur";
      package = pkgs.apple-cursor;
    };

    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };

    iconTheme = {
      name = "Colloid-dark";
      package = pkgs.colloid-icon-theme;
    };
  };

  imports = [
        ../../modules/shell/git.nix
        ../../modules/shell/zsh.nix
        ../../modules/editors/nvim/nvim.nix
        ../../pkgs/default.nix
        ../../darwin/modules/kitty/kitty.nix 
        ] ++ (lib.optionals pkgs.stdenv.isDarwin [
        ../../darwin/modules/sketchybar/sketchybar.nix
        ../../darwin/modules/yabai/yabai.nix
        ../../darwin/modules/skhd/skhd.nix
        ]) ++ (lib.optionals pkgs.stdenv.isLinux [
        ../../modules/desktop/hyprland/home.nix
        ../../pkgs/nixos.nix
        ../../modules/desktop/hyprland/extras.nix
        ../../modules/desktop/dunst/dunst.nix
        ../../modules/vm/vfio/default.nix
        ]);

  home = {

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };
    stateVersion = "23.05";
  };
}
