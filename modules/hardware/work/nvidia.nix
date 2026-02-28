{
  flake.modules.nixos.work =
    { config, pkgs, ... }:

    let
      nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      '';
    in
    {
      environment.systemPackages = [ nvidia-offload ];

      # services.xserver.videoDrivers = [ "nvidia" ];
      hardware = {
        graphics.enable = true;
        nvidia = {
          package = config.boot.kernelPackages.nvidiaPackages.production;
          open = false;
          prime = {
            offload.enable = true;
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:45:0:0";
          };
          modesetting.enable = true;
          powerManagement.enable = true;
        };
      };
    };
}
