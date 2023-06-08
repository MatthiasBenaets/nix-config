#
#  Home-manager configuration for macbook
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   └─ ./home.nix *
#   └─ ./modules
#       └─ ./programs
#           └─ ./alacritty.nix
#

{ pkgs, ... }:

{
  imports = 
    [
      ../modules/programs/alacritty.nix
      ../modules/shell/zsh.nix
      ../modules/editors/nvim/nvim.nix
      ./modules/sketchybar/sketchybar.nix
      ./modules/kitty/kitty.nix
      ./modules/skhd/skhd.nix
      ./modules/yabai/yabai.nix
    ];
  home = {                                        # Specific packages for macbook
    packages = with pkgs; [
      # Terminal
      pfetch
    ];
    stateVersion = "23.05";
  };

  programs = {
   neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
