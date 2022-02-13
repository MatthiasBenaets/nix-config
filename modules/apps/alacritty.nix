{ pkgs, ... }:

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = rec {
          normal.family = "Source Code Pro";
          bold = { style = "Bold"; };
          #size = 8;
        };
        offset = {
          x = -1;
          y = 0;
        };
      };
    };
  };
}
