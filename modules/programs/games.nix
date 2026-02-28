{
  flake.modules.nixos.games =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      # Controller
      # users.groups.plugdev.members = [
      #   "root"
      #   "${config.host.user.name}"
      # ];
      #
      # services.udev.extraRules = ''
      #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"
      # '';

      hardware.bluetooth = {
        enable = true;
        settings = {
          General = {
            AutoEnable = true;
            ControllerMode = "bredr";
          };
        };
      };

      hardware = {
        new-lg4ff.enable = false;
        steam-hardware.enable = true;
      };

      environment.systemPackages = [
        # pkgs.heroic
        # pkgs.lutris
        # pkgs.oversteer
        # pkgs.pcsx2
        # pkgs.prismlauncher
        # pkgs.retroarchFull
        pkgs.steam
      ];

      programs = {
        steam = {
          enable = true;
          remotePlay.openFirewall = false;
          dedicatedServer.openFirewall = false;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };
        gamemode.enable = true;
        # Better Gaming Performance
        # Steam: Right-click game - Properties - Launch options: gamemoderun %command%
        # Lutris: General Preferences - Enable Feral GameMode
        #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
      };
    };
}
