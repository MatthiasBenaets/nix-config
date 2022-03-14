#
# Git
#

{ pkgs, ... }:

{
  programs = {
    git = {
      userEmail = "matthias.benaets@gmail.com";
      userName = "MatthiasBenaets";
    };
  };
}
