#
#  Gaming: Steam + MC + Emulation
#  Do not forget to enable Steam play for all title in the settings menu
#  When connecting a controller via bluetooth, it might error out. To fix this, remove device, pair - connect - trust, wait for auto disconnect, sudo rmmod btusb, sudo modprobe btusb, pair again.
#

{ config, pkgs, nur, lib, vars, ... }:

let
  pcsx2 = pkgs.pcsx2.overrideAttrs (old: {      # PCSX2 Wrapper to run under X11
    nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];
    postFixup = ''
      wrapProgram $out/bin/pcsx2 \
        --set GDK_BACKEND x11
    '';
  });
in
{
  users.groups.plugdev.members = [ "root" "${vars.user}" ];
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"
  '';                                           # Group and udev rule needed to have access to the controller's gyro

  #hardware.new-lg4ff.enable = true;            # Force Feedback
  hardware.bluetooth = {                        # Wireless controller
    enable = true;
    settings = {
      General = {
        AutoEnable = true;
        ControllerMode = "bredr";
      };
    };
  };

  environment.systemPackages = [
    #config.nur.repos.c0deaddict.oversteer      # Steering Wheel Configuration
    #pkgs.heroic        # Game Launcher
    #pkgs.lutris        # Game Launcher
    #pkgs.prismlauncher # MC Launcher
    #pkgs.retroarchFull     # Emulator
    pkgs.steam          # Game Launcher
    #pcsx2                   # Emulator
  ];

  programs = {
    steam = {
      enable = true;
      #remotePlay.openFirewall = true;
    };
    gamemode.enable = true;                     # Better Gaming Performance
                                                # Steam: Right-click game - Properties - Launch options: gamemoderun %command%
                                                # Lutris: General Preferences - Enable Feral GameMode
                                                #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];                                            # Steam for Linux Libraries
}
