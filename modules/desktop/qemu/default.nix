#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./qemu
#               └─ default.nix *
# 

{ config, pkgs, ... }:

{                                             # Add libvirtd and kvm to userGroups
  boot ={
    kernelParams = [ "intel_iommu=on" ];      # or amd_iommu
    kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
    extraModprobeConfig = "options vfio-pci ids=1002:67DF,1002:AAF0"; # grep PCI_ID /sys/bus/pci/devices/*/uevent
  };

  environment = {
    systemPackages = with pkgs; [
      virt-manager
      qemu
      OVMF
    ];
  };

  virtualisation = {
    libvirtd = {
      enable = true;                   # Virtual drivers
      #qemuPackage = pkgs.qemu_kvm;
      qemu = {
        verbatimConfig = ''
         nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
        '';
      };
    };
    spiceUSBRedirection.enable = true;        # USB passthrough
  };

  users.groups.libvirtd.members = [ "root" "matthias" ];
}
