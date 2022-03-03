{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      radarr
      sonarr
      jackett
    ];
  };

  services = {
    jackett = {
      enable = true;
      user = "root";
      group = "root";
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
  };
}
