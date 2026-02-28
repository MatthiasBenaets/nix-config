{
  inputs,
  ...
}:

{
  flake.modules.homeManager.noctalia =
    {
      osConfig,
      pkgs,
      host,
      ...
    }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      home.packages = with pkgs; [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        quickshell
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
                if (osConfig.programs ? niri && osConfig.programs.niri.enable) then
                  [
                    {
                      id = "Launcher";
                    }
                    {
                      id = "Taskbar";
                    }
                  ]
                else
                  [
                    {
                      id = "Launcher";
                    }
                    {
                      id = "Workspace";
                      showApplications = true;
                      colorizeIcons = true;
                      hideUnoccupied = false;
                      showLabelsOnlyWhenOccupied = false;
                    }
                  ];
              center =
                if (osConfig.programs ? niri && osConfig.programs.niri.enable) then
                  [
                    {
                      id = "Workspace";
                    }
                  ]
                else
                  [ ];
              right = [
                {
                  id = "plugin:privacy-indicator";
                  defaultSettings = {
                    activeColor = "primary";
                    hideInactive = true;
                    inactiveColor = "none";
                    removeMargins = false;
                  };
                }
                {
                  id = "MediaMini";
                  hideMode = "hidden";
                  hideWhenIdle = true;
                  maxWidth = 30;
                  useFixedWidth = true;
                  showVisualizer = true;
                  visualizerType = "mirrored";
                  showAlbumArt = true;
                  showProgressRing = true;
                  compactMode = true;
                  compactShowAlbumArt = true;
                  compactShowVisualizer = true;
                }
                {
                  id = "Tray";
                  drawerEnabled = false;
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
          hooks = {
            enabled = true;
            startup = "noctalia-shell ipc call lockScreen lock";
          };
          plugins = {
            sources = [
              {
                enabled = true;
                name = "Official Noctalia Plugins";
                url = "https://github.com/noctalia-dev/noctalia-plugins";
              }
            ];
            states = {
              privacy-indicator = {
                enabled = true;
                sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              };
            };
            version = 1;
          };
          pluginSettings = {
            privacy-indicator = {
              hideInactive = true;
              removeMargins = true;
            };
          };
        };
      };
    };
}
