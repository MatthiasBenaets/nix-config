#
#  Power Management
#

{ config, lib, pkgs, vars, ... }:

{
  config = lib.mkIf ( config.laptop.enable ) {
    services = {
      tlp.enable = true;                          # Power Efficiency
      auto-cpufreq.enable = true;
    };

    home-manager.users.${vars.user} = {
      services = {
        cbatticon = {                             # Battery Level Notifications
          enable = true;
          criticalLevelPercent = 10;
          commandCriticalLevel = ''notify-send "battery critical!"'';
          lowLevelPercent = 30;
          iconType = "standard";
        };
      };
    };
  };
}
