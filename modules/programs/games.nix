#
#  Gaming: Steam + MC + Emulation
#  Do not forget to enable Steam play for all title in the settings menu
#

{ config, pkgs, nur, lib, unstable, vars, ... }:

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

  environment.systemPackages = [
    #config.nur.repos.c0deaddict.oversteer      # Steering Wheel Configuration
    #unstable.heroic        # Game Launcher
    #unstable.lutris        # Game Launcher
    #unstable.prismlauncher # MC Launcher
    #pkgs.retroarchFull     # Emulator
    unstable.steam          # Game Launcher
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
