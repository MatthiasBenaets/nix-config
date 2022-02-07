{ pkgs, ... }:

{
  imports = (import ../../modules/menu) ++ (import ../../modules/services) ++ (import ../../modules/shell); # ++ (import ...

  home = {
    username = "matthias";
    homeDirectory = "/home/matthias";

    packages = with pkgs; [
      neofetch
      polybar
    ];
  };

  programs = {
    home-manager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  xsession = {
    enable = true;
    numlock.enable = true;
    initExtra = ''
      polybar mybar &
    '';

    pointerCursor = {
      name = "Numix-Snow";
      package = pkgs.numix-cursor-theme;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Source Code Pro 11";
    };
  };

  home.stateVersion = "22.05";
}
