{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

in {

  xdg.enable = true;

  # todo: the duplication here sucks but I can't for the life of me figure it out.
  imports = [
        ../../modules/shell/git.nix
        ../../modules/programs/alacritty.nix
        ../../modules/shell/zsh.nix
        ../../modules/editors/nvim/nvim.nix
        ../../pkgs/default.nix
        ../../darwin/modules/sketchybar/sketchybar.nix
        ../../darwin/modules/yabai/yabai.nix
        ../../darwin/modules/skhd/skhd.nix
       ];

  home = {
    stateVersion = "23.05";
  };
}
