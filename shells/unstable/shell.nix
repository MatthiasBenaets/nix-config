#
#  Example shell that makes it possible to use stable and unstable packages
#  But you could also just add a new channel and using "$ nix-env -f channel:<name> -iA <package>", or via the flake.nix
#

let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  stable = import <nixpkgs> { };
  unstable = import unstableTarball { };
in
with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "Unstable-Shell";
  buildInputs = [ unstable.hello stable.world ];
  # permittedInsecurePackages = with pkgs; [
  #   "<package>"
  # ];
}
