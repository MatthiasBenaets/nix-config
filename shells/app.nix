let
  version = "103.0";
  buildnumber = "r20220613094641";
in { pkgs ? import <nixpkgs> {} }:
pkgs.appimageTools.wrapType2 {
  name = "firefox-nightly";
  src = pkgs.fetchurl {
    url = "https://github.com/srevinsaju/Firefox-Appimage/releases/download/firefox-nightly/firefox-nightly-${version}.${buildnumber}-x86_64.AppImage";
    sha256 = "8IYYbHnoq4hcpheIa5oPlrevalux5/xPAO0v32XumOc=";
  };
}

#
# This is an example on how to be able to use appimages.
# Here it installs firefox nightly form an appimage available online.
# If you have the appimage locally, just use src = <path>;
#
# Rather than using nix-shell, it better to run $ nix build -f app.nix
# and move the result symlink to your desired location or in a location within path.
#
# An even better solution is to install a package called "appimage-run".
# You will then be able to $ appimage-run <appimage> and start it without issues.
# Personally I recommend this solution.
#
