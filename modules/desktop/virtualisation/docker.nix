#
# Docker
#

{ config, pkgs, ... }:

{
  virtualisation = {
    docker.enable = true;
  };

  users.groups.docker.members = [ "matthias" ];

  environment = {
    interactiveShellInit = ''
      alias rtmp='docker run -p 1935:1935 tiangolo/nginx-rtmp'
    '';                                                           # Alias to easily start container
  };
}

# USAGE:
# list images (that can be run as container): docker images
# list containers (that are active): docker container ls
#   run images as container: docker run <repository name>
#   run with port binding (ports can be accessed over internet): docker run -p <host port>:<docker-port> <repository name>
#
# 1: RTMP Server for OBS Studio
#    INSTALL: docker run -d -p 1935:1935 --name nginx-rtmp tiangolo/nginx-rtmp
#    RUN: docker run -p 1935:1935 tiangolo/nginx-rtmp

