#
# Docker
#

{ config, pkgs, user, ... }:

{
  virtualisation = {
    docker.enable = true;
  };

  users.groups.docker.members = [ "${user}" ];

  #environment = {
  #  interactiveShellInit = ''
  #    alias rtmp='docker start nginx-rtmp'
  #  '';                                                           # Alias to easily start container
  #};

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}

# USAGE:
# list images (that can be run as container): docker images
# list containers (that are active): docker container ls
#   run images as container: docker run <repository name>
#   run with port binding (ports can be accessed over internet): docker run -p <host port>:<docker-port> <repository name>
#
# 1: Portainer
#    Create volume: docker volume create portainer_data
#    Create and start: docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
#                         --restart=always \
#                         -v /var/run/docker.sock:/var/run/docker.sock \
#                         -v portainer_data:/data \
#                         portainer/portainer-ce:latest
#
# 2: RTMP Server for OBS Studio
#    Create: docker run -d -p 1935:1935 --name nginx-rtmp --restart=always tiangolo/nginx-rtmp
#
# 3: Homer
#    Create: docker run -d \
#      -p 8080:8080 \
#      -v </your/local/assets/>:/www/assets \
#      --restart=always \
#      b4bz/homer:latest
# 
