#
# Media Services: Plex, Torrenting and automation
#

{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      radarr
      sonarr
      jackett
      bazarr
      handbrake
      deluge
    ];
  };

  services = {
    jackett = {
      enable = true;
    };
    radarr = {
      enable = true;
      user = "root";
      group = "users";
    };
    sonarr = {
      enable = true;
      user = "root";
      group = "users";
    };
    bazarr = {
      enable = true;
      user = "root";
      group = "users";
    };
    deluge = {
      enable = true;
      web.enable = true;
      user = "root";
      group = "users";
    };
  };
}

# literally can't be bothered anymore with user permissions.
# So everything with root, add permissions 775 with group users in radarr and sonar
# Radarr & Sonarr: chmod 775
# Bazarr: chmod 660
# Deluge: 
#   Connection Manager: localhost:58846
#   Preferences: Change download folder and enable Plugins-label
