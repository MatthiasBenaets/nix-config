#
#  Terminal Emulator
#

{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    programs = {
      alacritty = {
        enable = true;
        settings = {
          font = {
            normal.family = "FiraCode Nerd Font";
            bold = { style = "Bold"; };
            size = 11;
          };
          offset = {
            x = -1;
            y = 0;
          };
        };
      };
    };
  };
}
