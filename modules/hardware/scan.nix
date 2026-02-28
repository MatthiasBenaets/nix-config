{
  flake.modules.nixos.scan =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        simple-scan
      ];

      hardware.sane = {
        enable = true;
        extraBackends = [ pkgs.sane-airscan ];
      };
    };
}
