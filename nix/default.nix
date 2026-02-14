{ inputs, overlays, vars, ... }:

let
  system = "x86_64-linux";
  lib = inputs.nixpkgs.lib;
  pkgs = lib.applyOverlays inputs.nixpkgs.legacyPackages.${system} overlays;
in
{
  pacman = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs vars; };
    modules = [
      ./pacman.nix
      {
        home = {
          username = "${vars.user}";
          homeDirectory = "/home/${vars.user}";
          packages = [ pkgs.home-manager ];
          stateVersion = "22.05";
        };
      }
    ];
  };
}
