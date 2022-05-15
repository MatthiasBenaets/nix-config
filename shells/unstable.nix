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

# This is an example nix-shell that makes it possible to use stable and unstable packages
