#
# Bar
#

{ config, lib, pkgs, host, user, ...}:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  home-manager.users.${user} = {                           # Home-manager waybar config
    programs.waybar = {
      enable = true;
      systemd ={
        enable = true;
        target = "sway-session.target";                     # Needed for waybar to start automatically
      };

      style = ''
        * {
          border: none;
          text-shadow: 0px 0px 5px #000000;
        }
        button:hover {
          background-color: rgba(80,100,100,0.4);
        }
        window#waybar {
          background-color: rgba(0,0,0,0.5);
          background: transparent;
          transition-property: background-color;
          transition-duration: .5s;
          border-bottom: none;
        }
        window#waybar.hidden {
          opacity: 0.2;
        }
        #tray {
          color: #999999;
          background-clip: padding-box;
        }
      '';
      settings = with host; {
        Main = {
          layer = "top";
          position = "top";
          height = 20;
          width = 200;
          output = if hostName == "desktop" || hostName == "beelink" then [
            "${mainMonitor}"
            "${secondMonitor}"
          ] else if hostName == "work" then [
            "${mainMonitor}"
            "${secondMonitor}"
            "${thirdMonitor}"
          ] else [
            "${mainMonitor}"
	  ];
          tray = { spacing = 5; };

          modules-center = [ "tray" ];
        };
      };
    };
  };
}
