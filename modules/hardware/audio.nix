{
  flake.modules.nixos.audio =
    { pkgs, ... }:
    {
      services = {
        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;
          jack.enable = true;
        };
        pulseaudio.enable = false;
      };

      security.rtkit.enable = true;

      environment.systemPackages = with pkgs; [
        alsa-utils
        pavucontrol
        pipewire
        pulseaudio
        qpwgraph
      ];
    };
}
