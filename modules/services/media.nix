#
# Media Services: Plex, Torrenting and automation
#

{ config, pkgs, lib, ... }:

{
  services = {
    radarr = {                  #7878
      enable = true;
      user = "root";
      group = "users";
    };
    sonarr = {                  #8989
      enable = true;
      user = "root";
      group = "users";
    };
    bazarr = {                  #6767
      enable = true;
      user = "root";
      group = "users";
    };
    prowlarr = {                #9696
      enable = true;
    };
    deluge = {                  #8112
      enable = true;
      web.enable = true;
      user = "root";
      group = "users";
    };
  };
}

# literally can't be bothered anymore with user permissions.
# So everything with root, add permissions 775 with group users in radarr and sonarr
# (Under Media Management - Show Advanced | Under Subtitles)
# Radarr & Sonarr: chmod 775
# Bazarr: chmod 664
# Prowlarr should just work
# Deluge: 
#   Connection Manager: localhost:58846
#   Preferences: Change download folder and enable Plugins-label
