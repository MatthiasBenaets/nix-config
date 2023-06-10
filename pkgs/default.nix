### None of this is currently in use at the moment. Got the auth plugin some other way
{ pkgs, ... }:
let
in {
    imports = [
      ./core.nix
      ./dev.nix
      ./kube.nix
    ];
	
     programs.zsh.enable = true;                            # Shell needs to be enabled
     programs.neovim.enable = true;
  }
