{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  services = {
    upower.enable = true;

    xserver = {
      enable = true;

      layout = "be";
      xkbOptions = "eurosign:e";

      libinput = {
        enable = true;
        touchpad.disableWhileTyping = true;
      };

      serverLayoutSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime"     "0"
      '';

      displayManager = {
        lightdm = {
          enable = true;
        };
        defaultSession = "none+bspwm";
      };
      windowManager.bspwm = {
        enable = true;
      };
    }; 
  };

  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  services.blueman.enable = true;

  systemd.services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    xorg.xev
    xorg.xkill    
    
    alacritty
    sxhkd
  ];
}
