#
# The latest OpenSSL package uses SSL3, meaning it will no longer support certain legacy protocols.
# I guess my work's network isn't set up as securaly as they want us to think.
# This patch makes it back available to connect to legacy servers.
#

{ config, lib, pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: rec {
    wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
      patches = attrs.patches ++ [ ./eduroam.patch ];
    });
  };
}
