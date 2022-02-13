#
#  Home-manager configuration for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ ./desktop
#   │   │   └─ home.nix *
#   │   └─ home.nix
#   └─ ./modules
#       ├─ ./apps
#       │   └─ default.nix
#       ├─ ./services
#       │   └─ default.nix
#       └─ ./shell
#           └─ default.nix


{ pkgs, ... }:

{
  imports =				# Importing all the different modules
    [(import ../home.nix)]; #++
  #  (import ../../modules/apps) ++ 
  #  (import ../../modules/services) ++
  #  (import ../../modules/shell); 

  home = {
    packages = with pkgs; [
      firefox
    ];
  };
}
