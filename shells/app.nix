let
  version = "102.0";
  buildnumber = "r20220516215740";
in { pkgs ? import <nixpkgs> {} }:
pkgs.appimageTools.wrapType2 {
  name = "firefox nightly";
  src = pkgs.fetchurl {
    url = "https://github.com/srevinsaju/Firefox-Appimage/releases/download/firefox-nightly/firefox-nightly-${version}.${buildnumber}-x86_64.AppImage";
    sha256 = "W88aZ4fT7/kCE4R8kTsSXu3tCIOM5zk7w9kxLTSm3fA=";
  };
}

#
# This is an example on how to be able to use appimages.
# Here it installs firefox nightly form an appimage available online.
# If you have the appimage locally, just use src = <path>;
#
# Rather than using nix-shell, it better to run $ nix build -f app.nix
# and move the result symlink to your desired location.
#
