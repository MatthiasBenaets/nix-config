{
  flake.modules.nixos.vm =
    {
      config,
      lib,
      ...
    }:
    {
      boot.initrd.availableKernelModules = [
        "ata_piix"
        "xhci_pci"
        "sd_mod"
        "sr_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];
      boot = {
        loader = {
          grub = {
            enable = true;
            device = "/dev/sda";
          };
          timeout = 1;
        };
      };

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      virtualisation.virtualbox.guest.enable = false;
    };
}
