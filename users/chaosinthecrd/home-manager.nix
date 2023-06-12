{ lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

in {

  xdg.enable = true;

  imports = [
        ../../modules/shell/git.nix
        ../../modules/programs/alacritty.nix
        ../../modules/shell/zsh.nix
        ../../modules/editors/nvim/nvim.nix
        ../../pkgs/default.nix
        ] ++ (lib.optionals pkgs.stdenv.isDarwin [
        ../../darwin/modules/sketchybar/sketchybar.nix
        ../../darwin/modules/yabai/yabai.nix
        ../../darwin/modules/skhd/skhd.nix
        ../../darwin/modules/kitty/kitty.nix 
        ]) ++ (lib.optionals pkgs.stdenv.isLinux [
        ../../modules/desktop/hyprland/home.nix
        ../../modules/desktop/river/home.nix
        ../../modules/programs/rofi.nix
        ../../modules/programs/waybar.nix
        ../../modules/programs/wofi.nix
        ]);

  home = {
    stateVersion = "23.05";
  };
}
