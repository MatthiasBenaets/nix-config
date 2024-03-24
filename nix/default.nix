#
#  These are the diffent profiles that can be used when using Nix on other distros.
#  Home-Manager is used to list and customize packages.
#
#  flake.nix
#   └─ ./nix
#       ├─ default.nix *
#       └─ <host>.nix
#

{ inputs, nixpkgs, home-manager, nixgl, vars, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  pacman = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs nixgl vars; };
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
