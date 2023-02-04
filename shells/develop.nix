#
# Example of a development shell flake
# Rename to flake.nix
# Can be run with "$ nix develop" or "$ nix develop </path/to/flake.nix>#<host>"
#

{
  description = "A development environment";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
  };

  outputs = inputs:
    let
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      pypi = with pkgs; (ps: with ps; [
        pip
      ]);
    in {
      # default host
      devShells.x86_64-linux.default = inputs.nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = [ (pkgs.python310.withPackages pypi) ];
      };
      # py311 host
      devShells.x86_64-linux.py311 = inputs.nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = [ (pkgs.python311.withPackages pypi) ];
      };
    };
}
