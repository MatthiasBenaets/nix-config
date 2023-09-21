#
#  Docker
#

{ config, pkgs, vars, ... }:

{
  virtualisation = {
    docker.enable = true;
  };

  users.groups.docker.members = [ "${vars.user}" ];

  environment.systemPackages = with pkgs; [
    docker                  # Containers
    docker-compose          # Multi-Container
  ];
}
