{
  flake.modules.nixos.beelink =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.kernelPackages = pkgs.linuxPackages_latest;

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot.kernelModules = [ "kvm-intel" ]; # btintel
      boot.kernelParams = [
        "i915.enable_guc=3"
        "pcie_aspm=off"
      ];
      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 3;
          };
          efi = {
            canTouchEfiVariables = true;
          };
          timeout = 5;
        };
      };

      services.thermald.enable = true;
      powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

      hardware.enableRedistributableFirmware = lib.mkDefault true;
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      hardware = {
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver
            intel-compute-runtime
            # intel-vaapi-driver
            vpl-gpu-rt
            libva-vdpau-driver
            libvdpau-va-gl
          ];
        };
      };
    };
}
