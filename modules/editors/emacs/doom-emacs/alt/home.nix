#
# Doom Emacs: native install with home manager.
# Recommended to comment out this import first install because script will cause issues. It your want to use doom emacs, use the correct location or change in script.
# In my opinion better then nix-community/nix-doom-emacs but more of a hassle to install on a fresh install.
# Unfortunately an activation script like with the default nix options is not possible since home.activation and home.file.*.onChange will time out systemd.
#
# flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ ./doom-emacs
#                   └─ default.nix *
#

{ config, pkgs, location, ... }:

{
  home = {
    file.".doom.d" = {                            # Get Doom Emacs
      source = ./doom.d;                          # Sets up symlink name ".doom.d" for file "doom.d"
      recursive = true;                           # Allow symlinking a directory
      onChange = builtins.readFile ./doom.sh;     # If an edit is detected, it will run this script. Pretty much the same as what is now in default.nix but actually stating the terminal and adding the disown flag to it won't time out
    };

    packages = with pkgs; [
      alacritty #(for the script)
      ripgrep
      coreutils
      fd
    ];
  };

  programs = {
    emacs.enable = true;                        # Get Emacs
  };
}
