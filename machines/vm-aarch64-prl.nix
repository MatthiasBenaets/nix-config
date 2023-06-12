{ config, pkgs, lib, ... }: {
  imports = [
    ./vm-shared.nix
  ];

  # The official parallels guest support does not work currently.
  # https://github.com/NixOS/nixpkgs/pull/153665

  # Interface is this on my M1
  networking.interfaces.enp0s5.useDHCP = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = false;
  environment.systemPackages = with pkgs; [
  waybar
  ];
}
