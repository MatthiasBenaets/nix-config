#
#  Example nix-shell that makes it possible to use stable and unstable packages
#  But you could also just add a channel and using nix-env with $ nix-env -f channel:<name> -iA <package>
#

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  stable = import <nixpkgs> {};
  unstable = import unstableTarball {};
in with import <nixpkgs> {};                  # Import nixpkgs again or stdenv won't work
stdenv.mkDerivation {
  name = "Unstable-Shell";
  buildInputs = [ unstable.hello stable.world ];
  #permittedInsecurePackages = with pkgs; [
  #  "<package>"
  #];
}
