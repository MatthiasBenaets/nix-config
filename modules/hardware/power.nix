#
#  Power Management
#

{ config, lib, pkgs, host, vars, ... }:

{
  config = lib.mkIf ( config.laptop.enable ) {
    services = {
      tlp.enable = false;                         # Disable due to suspend not working when docked and connected to AC
      auto-cpufreq.enable = true;                 # Power Efficiency
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
