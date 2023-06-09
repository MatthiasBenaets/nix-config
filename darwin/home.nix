{ config, lib, pkgs, ... }:


{

  imports = [
    ./modules/sketchybar/sketchybar.nix
    ./modules/yabai/yabai.nix
    ./modules/skhd/skhd.nix
  ];

}
