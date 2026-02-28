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

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot.kernelModules = [ "kvm-intel" ]; # btintel
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

      powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      hardware = {
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver
            intel-vaapi-driver
            libva-vdpau-driver
            libvdpau-va-gl
          ];
        };
      };
    };
}
