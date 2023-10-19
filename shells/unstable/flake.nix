#
#  Example of a flake shell
#  Can be run with "$ nix develop" or "$ nix develop </path/to/flake.nix>#<host>"
#

{
  description = "Use stable and unstable packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;                                        # Allow Proprietary Software
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.ltris ];
      };
    };
}
