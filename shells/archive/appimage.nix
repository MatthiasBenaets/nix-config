#
# Example on how to run appimages
# This example installs firefox nightly form an appimage available online
# If you have the appimage locally, just use src = <path>;
#
# In this case, rather than using nix-shell, it's better to run "$ nix build -f appimage.nix"
# and move the result symlink to your desired location or in a location within PATH
#
# A better solution is to install "appimage-run"
# Appimage can then be run via "$ appimage-run <appimage>" and will (hopefully) start without issues
#

let
  version = "103.0";
  buildnumber = "r20220613094641";
in
{ pkgs ? import <nixpkgs> { } }:
pkgs.appimageTools.wrapType2 {
  name = "firefox-nightly";
  src = pkgs.fetchurl {
    url = "https://github.com/srevinsaju/Firefox-Appimage/releases/download/firefox-nightly/firefox-nightly-${version}.${buildnumber}-x86_64.AppImage";
    sha256 = "8IYYbHnoq4hcpheIa5oPlrevalux5/xPAO0v32XumOc=";
  };
}
