{ pkgs, ... }:

{
  imports = [
      (fetchTarball {
      url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
      sha256 = "1rdn70jrg5mxmkkrpy2xk8lydmlc707sk0zb35426v1yxxka10by";
     }) ] ++
    (import ../../modules/desktops/virtualisation);

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  hyprland.enable = true;

  programs.nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
      libraries = with pkgs; [
         stdenv.cc.cc.lib
         zlib
      ];
  };

  environment = {
    systemPackages = with pkgs; [
    ];
  };

}
