let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  #pkgs = import <nixpkgs> {};
  unstable = import unstableTarball {};

  shell = unstable.mkShell {
    buildInputs = [ unstable.etcher ];
    permittedInsecurePackages = [
      "electron-12.2.3"
    ];
  };
in shell

# This no longer works. Better to just use $ NIXPKGS_ALLOW_INSECURE=1 nix run nixpkgs#etcher --impure
