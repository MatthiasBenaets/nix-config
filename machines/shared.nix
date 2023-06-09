## Essentially the shared `configuration.nix` for all the machines (including darwin)
{ config, pkgs, user, system, ... }:

{
  modules = [
    ../modules/fonts/fonts.nix
  ];

  nix = {
    package = pkgs.nix;
    gc = {                                # Garbage collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };
}
