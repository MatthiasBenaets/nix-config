{
  flake.modules.darwin.base = {
    homebrew = {
      enable = true;
      onActivation = {
        upgrade = false;
        # cleanup = "zap";
      };
      casks = [
        "appcleaner"
        "betterdisplay"
        "firefox"
        "moonlight"
        "obs"
        "vlc"
        # "canon-eos-utility"
      ];
      masApps = {
        "wireguard" = 1451685025;
      };
    };

    environment.systemPath = [
      "/opt/homebrew/bin"
    ];
  };

  flake.modules.darwin.homebrewIntel = {
    homebrew = {
      brews = [
        "docker-compose"
      ];
      casks = [
        "aldente"
        "alfred"
        "docker-desktop"
        "jellyfin-media-player"
        "moonlight"
        "rectangle"
        "stremio"
        # "virtualbox" # sudo codesign --force --deep --sign - /Applications/VirtualBox.app/Contents/Resources/VirtualBoxVM.app
      ];
    };
  };

  flake.modules.darwin.homebrewM1 = {
    homebrew = {
      brews = [
        "ansible"
        "ansible-lint"
        "docker-compose"
      ];
      casks = [
        "adobe-creative-cloud"
        "autodesk-fusion"
        # "bettertouchtool"
        "blender"
        # "connectiq"
        "darktable"
        "dbeaver-community"
        "deluge"
        "docker-desktop"
        "freecad"
        "garmin-express"
        "google-chrome"
        "handbrake-app"
        "jellyfin-media-player"
        "love"
        "local"
        "linearmouse"
        "mkvtoolnix-app"
        # "obsidian"
        "openmtp"
        "orcaslicer"
        "portfolioperformance"
        "httpie-desktop"
        # "r-app"
        "raycast"
        # "rstudio"
        "stremio"
        "upscayl"
        "utm"
        "visual-studio-code"
        "wacom-tablet"
        "xnviewmp"
      ];
      masApps = {
        "Adguard for Safari" = 1440147259; # Safari
        "Bitwarden" = 1352778147; # Safari
        "Connective Plugin" = 1428740565; # Eid
        "Developer" = 640199958; # Apple
        "Keynote" = 361285480; # Office
        "LanguageTool - Grammer Checker" = 1534275760; # Safari
        "Photomator" = 1444636541; # Photo
        "Microsoft Remote Desktop" = 1295203466;
        "Numbers" = 361304891; # Office
        "Pages" = 361309726; # Office
        "RemoteDrive" = 6502180430; # Filezilla
        "Sauce for Strava™" = 1570922521; # Safari
        "Userscripts" = 1463298887; # Safari
        "Windows App" = 1295203466; # RDP
        "Wireguard" = 1451685025; # VPN
        "Xcode" = 497799835; # IDE
      };
    };
  };

  flake.modules.darwin.homebrewWork = {
    homebrew = {
      brews = [
        "ansible"
        "ansible-lint"
        "docker-compose"
        # "gemini-cli"
      ];
      casks = [
        # "adobe-creative-cloud"
        "antigravity-cli"
        # "bettertouchtool"
        "claude-code"
        "copilot-cli"
        "cyberduck"
        "dbeaver-community"
        "docker-desktop"
        "handbrake-app"
        "jordanbaird-ice@beta"
        "local"
        "linearmouse"
        "moonlight"
        "obs"
        "ollama-app"
        "positron"
        "postman"
        "quarto"
        "r-app"
        "raycast"
        "rstudio"
        "utm"
        "visual-studio-code"
        "xquartz"
      ];
    };
  };
}
