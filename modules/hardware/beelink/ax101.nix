#
# Bluetooth fix for ax101 (ax201)
# In BIOS disable hibernate and fast boot, enable network stack
# On dualboot, disable fast startup on Windows
#

{ pkgs, ...}:

let
  linux-firmware-ax101bt = pkgs.fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "c7c5ca392684b6ea79be8242d72e3a83758343e1";
    sha256 = "sha256-iqVXIdZhEuIclsdqsVCqnMsQOGm/gZYwsS42eeSrMpE=";
  };

  ax101 = self: super: {
    linux-firmware = super.linux-firmware.overrideAttrs (prev: {
      version = "git+c7c5ca392684b6ea79be8242d72e3a83758343e1";
      src = linux-firmware-ax101bt;
      outputHash = "sha256-CkDUwfI6WMzwr0yhpk4+3NxY696EItArCeDh528v2lc=";
    });
  };
in
{
  nixpkgs.overlays = [ ax101 ];
}

