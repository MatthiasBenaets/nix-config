{ pkgs, ... }:

{
  programs = {
    emacs.enable = true;                        # Get Emacs
  };

  home.file.".doom.d" = {                       # Get Doom Emacs
    source = ./doom.d;                            # Sets up symlink name ".doom.d" for file "doom.d"
    recursive = true;                             # Allow symlinking a directory
    onChange = builtins.readFile ./doom.sh;       # If an edit is detected, it will run this script
  };
}
