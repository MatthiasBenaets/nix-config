{
  flake.modules.darwin.intel =
    { pkgs, ... }:
    {
      system = {
        defaults = {
          NSGlobalDomain = {
            KeyRepeat = 1;
            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticSpellingCorrectionEnabled = false;
            "com.apple.keyboard.fnState" = true;
            "com.apple.mouse.tapBehavior" = 1;
            "com.apple.trackpad.enableSecondaryClick" = true;
          };
          dock = {
            autohide = false;
            largesize = 36;
            tilesize = 24;
            magnification = true;
            mineffect = "genie";
            orientation = "bottom";
            showhidden = false;
            show-recents = false;
            minimize-to-application = true;
          };
          finder = {
            AppleShowAllFiles = false;
            ShowPathbar = true;
            QuitMenuItem = false;
          };
          # keyboard = {
          #   remapCapsLockToEscape = true;
          # };
          trackpad = {
            Clicking = true;
            TrackpadRightClick = true;
          };
          magicmouse = {
            MouseButtonMode = "TwoButton";
          };
          # CustomUserPreferences = {
          # # /Users/${vars.user}/Library/Preferences/
          # }
          # CustomSystemPreferences = {
          # # /Users/${vars.user}/Library/Preferences/
          # }
        };
        activationScripts.postActivation.text = "sudo chsh -s ${pkgs.zsh}/bin/zsh";
        # # Reload all settings without relog/reboot
        # activationScripts.postUserActivation.text = ''
        #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        # '';
      };
    };
}
