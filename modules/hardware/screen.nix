{
  flake.modules.nixos.screen =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        brightnessctl
      ];
    };
}
