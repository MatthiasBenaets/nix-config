#
# Qemu/KVM with virt-manager 
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
      gvfs                                    # Used for shared folders between linux and windows
    ];
  };

  services = {                                # Enable file sharing between OS
    gvfs.enable = true;
  };

  virtualisation = {
    libvirtd = {
      enable = true;                          # Virtual drivers
      #qemuPackage = pkgs.qemu_kvm;           # Default
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

#FOR WINDOWS

#SHARED FOLDER
# Two options:
# 1. Since this setup make use of iommu, you can pass through external usb hard drives or a specific PCI storage devices
# 2. Set up shared folders in windows guest that can be accessed by host
# 2.0. Enable above service gvfs (this is used in the file manager to actually connect to the windows directory)
# 2.1. Log in to Windows
# 2.2. Go to "Netowrk and Sharing Center"
# 2.3. Click "Change advanced sharing settings" and enable all settings for Private, Guest or Public and All Networks
# 2.3.1. Under "All Networks" you can disable "Password protected sharing" but it seems for optimal use, it's better to still give the password in the file manager
# 2.4. (possibly optional), select a folder and click "Properties", "Sharing", "Advanced Sharing"
# 2.4.1. Enable "Share this file"
# 2.4.2. Under "Permissions", allow full control. Apply
# 2.5. Click "Share" and use de drop down to add "Everyone" and change "Permission Level" to "Read/Write". Share, Done
# 2.6. Search for services and open menu
# 2.6.1. Search for below serices. Right click and select "Properties". "Startup type" = Automatic
# 2.6.1.1. SSDP Discovery
# 2.6.1.2. uPnPDevice Host
# 2.6.1.3. Functions Discovery Provider Host
# 2.6.1.4. Functions Discovery Resource Publication
# 2.7. Find IP of virtual device and make sure you can ping it.
# 2.8. In file manager add connection
# 2.8.1. For example in PCManFM
# 2.8.2. Search for smb://*ip*/
# 2.8.3. You can even specify specific folder smb://*ip*/users/Matthias/Desktop/share
# 2.8.4. If prompted to log in, do it, otherwise it might close on its own.
# 2.9. If there are any issues, maybe disable firewall on guest
# 2.10. Recommended to bookmark location for later
# Note:
# This there is no passthrough, its recommended to install the windows kvm guest drivers.
# Can be found on github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md
# Add this as CD storage in virt manager
# It can than be accest in the windows and the guest driver exe's can be run.
# Also, change video in virt-manager to virtio. This will fix the resolution

#SINGLE GPU PASSTHROUGH
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
# 6. Start Installation (let it run without interference and do steps below)
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
