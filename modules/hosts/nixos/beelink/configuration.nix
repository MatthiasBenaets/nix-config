{
  flake.modules.nixos.beelink =
    { config, pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          google-cloud-sdk-gce # Google Cloud
          jellyfin-desktop # Media Player
          moonlight-qt # Remote Streaming
          obs-studio # Live Streaming
          orca-slicer # 3D Slicer
        ];
      };
    };
}
