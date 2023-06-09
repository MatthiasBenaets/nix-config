{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

in {

  xdg.enable = true;

  imports = 
    [
      ../../modules/programs/alacritty.nix
      ../../modules/shell/zsh.nix
      ../../modules/editors/nvim/nvim.nix
      # this needs to be moved at some point
      ../../darwin/modules/kitty/kitty.nix
      ../../pkgs/default.nix
    ] ++ (lib.optionals isDarwin [
      # this is where the packages specific for darwin can live.
      # it doesn't exist at the moment though.
      ../../darwin/home.nix
    ]) ++ (lib.optionals isLinux [
      # Blank for now before adding things 
    ]);

}
