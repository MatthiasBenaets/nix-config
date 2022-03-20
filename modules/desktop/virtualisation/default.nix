#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./virtualisation
#               └─ default.nix *
# 

{ config, pkgs, ... }:

{                                             # Add libvirtd and kvm to userGroups
  #boot ={
  #  kernelParams = [ "intel_iommu=on" "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];      # or amd_iommu (cpu)
  #  kernelModules = [ "vendor-reset" "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd"];
  #  extraModulePackages = [ config.boot.kernelPackages.vendor-reset ]; # Presumably fix for GPU Reset Bug
  #  extraModprobeConfig = "options vfio-pci ids=1002:67DF,1002:AAF0"; # grep PCI_ID /sys/bus/pci/devices/*/uevent
  #  kernelPatches = [
  #    {
  #    name = "vendor-reset-reqs-and-other-stuff";
  #    patch = null;
  #    extraConfig = ''
  #    FTRACE y
  #    KPROBES y
  #    FUNCTION_TRACER y
  #    HWLAT_TRACER y
  #    TIMERLAT_TRACER y
  #    IRQSOFF_TRACER y
  #    OSNOISE_TRACER y
  #    PCI_QUIRKS y
  #    KALLSYMS y
  #    KALLSYMS_ALL y
  #    ''; 
  #    }
  #  ];
  #};

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
    docker.enable = true;
  };

  users.groups.libvirtd.members = [ "root" "matthias" ];
  users.groups.docker.members = [ "matthias" ];
}

# General Guide: gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/home
# 1. Download ISO
# 2. Download latest Video BIOS from techpowerup.com/vgabios (Sapphire RX580 8Gb)
# 2.1. Sudo mkdir /var/lib/libvirt/vbios/
# 2.2. Sudo mv ~/Downloads/*.rom /var/lib/libvirt/vbios/GPU.rom
# 2.3. Cd /var/lib/libvirt/vbios/
# 2.4. Sudo chmod -R 660 GPU.rom
# 3. Launch virt-manager
# 4. File - Add Connection
# 5. Create Virtual Machine
# 5.1 Select ISO and mark it as win10
# 5.2 Give temporary RAM
# 5.3 Customize configuration before install
# 5.4 Overview - Firmware - UEFI x86_64: /usr/*/OVMF_CODE.fd
# 5.5 Allow XML Editing via Edit - Preferences
# 5.6 Edit XML - Remove rtc & pit line. Change hpet to "yes"
# 6. Start Installation
# 6.1 Press Esc, type exit, select boot-manager DVD ROM
# 6.2 Do installation, select Pro version.
# 6.3 Install hooks (Step 7 in guide)
# 7. Close VM
# 8. Edit VM
# 8.1 Remove everything spice (Display, Video QXL, Serial, Channel Spice)
# 8.2 Remove CD Rom
# 8.3 Add PCI hardware (GPU: 01:00:0 & 01:00:1 (most likely))
# 8.3 Add Mouse, Keyboard (PCI USB Controller in PCI Host Device or USB Host Device)
# 9. Select GPU and open XML
# 9.1 Add line "<rom file='/var/lib/libvirt/vbios/GPU.rom'/>" under "</source>"
# 9.2 Do for both 01:00:0 and 01:00:1
# 10. Edit CPU
# 10.1 Disable "Copy host CPU configuration" and select "host-passthrough"
# 10.2 Edit topology: Sockets=1 Cores=Total/2 Threads=2
# 10.3 Edit XML cpu under topology
# 10.3.1  Add "<feature policy='require' name='topoext'/>" for AMDCPU
# 10.3.2  Add "<feature policy='disable' name='smep'/>" for Intel CPU
# 11 Change memory to prefered (12GB for 16GB Total)
# 12 Start VM
# 13 Install correct video drivers
