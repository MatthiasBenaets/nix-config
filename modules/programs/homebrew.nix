{
  flake.modules.darwin.base = {
    homebrew = {
      enable = true;
      onActivation = {
        upgrade = false;
        cleanup = "zap";
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
        "garmin-express"
        "google-chrome"
        "handbrake-app"
        "jellyfin-media-player"
        "love"
        "local"
        "linearmouse"
        "mkvtoolnix-app"
        # "obsidian"
        "ollama-app"
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
        # "FileZilla Pro - FTP and Client" = 1298486723;
        # "FileZilla Pro RemoteDrive" = -2087754162;
        "Keynote" = 409183694;
        "LanguageTool - Grammer Checker" = 1534275760; # Safari
        "Microsoft Remote Desktop" = 1295203466;
        "Numbers" = 409203825;
        "Pages" = 409201541;
        "Sauce for Strava™" = 1570922521; # Safari
        "Userscripts" = 1463298887; # Safari
        "Xcode" = 497799835;
      };
    };
  };

  flake.modules.darwin.homebrewWork = {
    homebrew = {
      brews = [
        "ansible"
        "ansible-lint"
        "docker-compose"
      ];
      casks = [
        # "adobe-creative-cloud"
        # "bettertouchtool"
        "cyberduck"
        "dbeaver-community"
        "docker-desktop"
        "jordanbaird-ice@beta"
        "local"
        "linearmouse"
        "moonlight"
        "obs"
        "ollama-app"
        "postman"
        "quarto"
        "r-app"
        "raycast"
        "rstudio"
        "utm"
        "xquartz"
      ];
    };
  };
}
