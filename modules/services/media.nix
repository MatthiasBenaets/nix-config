{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      radarr
      sonarr
      jackett
      bazarr
      handbrake
    ];
  };

  services = {
    jackett = {
      enable = true;
    };
    radarr = {
      enable = true;
      user = "root";
      group = "root";
    };
    sonarr = {
      enable = true;
      user = "root";
      group = "root";
    };
    bazarr = {
      enable = true;
      user = "root";
      group = "users";
    };
  };
}

# literally can't be bothered anymore with user permissions.
# Any of the services can't communicate with qbittorrent.
# Deluge can't save to custom location
# So everything with root and add permissions 775 with group users in radarr and sonar
# Radarr & Sonarr: chmod 775
# Bazarr: chmod 660
