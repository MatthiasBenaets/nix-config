{ pkgs, user, ... }:

{
  programs.zsh.enable = true;

  users.users.chaosinthecrd = {
    isNormalUser = true;
    home = "/home/chaosinthecrd";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
  };

}
