{ config, inputs, lib, pkgs, vars, ... }:

{
  config = lib.mkIf (config.wlwm.enable) {
    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      quickshell
    ];

    home-manager.users.${vars.user} =
      {
        imports = [
          inputs.noctalia.homeModules.default
        ];

        programs.noctalia-shell = {
          enable = true;
          settings = {
            bar = {
              barType = "simple";
              position = "top";
              density = "default";
              showCapsule = true;
              capsuleColorKey = "none";
              outerCorners = false;
              widgets = {
                left =
                  if (config.programs.niri.enable) then [
                    {
                      id = "Launcher";
                    }
                    {
                      id = "Taskbar";
                    }
                  ] else [
                    {
                      id = "Launcher";
                    }
                    {
                      id = "Workspace";
                    }
                  ];
                center =
                  if (config.programs.niri.enable) then [
                    {
                      id = "Workspace";
                    }
                  ] else [ ];
                right = [
                  {
                    id = "MediaMini";
                  }
                  {
                    id = "Tray";
                  }
                  {
                    id = "Bluetooth";
                  }
                  {
                    id = "Volume";
                  }
                  {
                    id = "NotificationHistory";
                  }
                  {
                    id = "ControlCenter";
                  }
                  {
                    id = "Clock";
                  }
                ];
              };
            };
            location = {
              name = "Hasselt";
            };
            dock = {
              enabled = false;
              position = "bottom";
              displayMode = "auto_hide";
              colorizeIcons = true;
              animationSpeed = 2;
            };
            colorSchemes = {
              useWallpaperColors = true;
              darkMode = true;
              generationMethod = "tonal-spot";
            };
            audio = {
              visualizerType = "mirrored";
            };
          };
        };
      };
  };
}
