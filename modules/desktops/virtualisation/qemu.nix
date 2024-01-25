#
#  Qemu/KVM With Virt-Manager
#

{ pkgs, vars, ... }:

{
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_nsrs=1
  '';                                         # For OSX-KVM

  users.groups = {
    libvirtd.members = [ "root" "${vars.user}" ];
    kvm.members = [ "root" "${vars.user}" ];
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        verbatimConfig = ''
         nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
        '';
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      virt-manager    # VM Interface
      virt-viewer     # Remote VM
      qemu            # Virtualizer
      OVMF            # UEFI Firmware
      gvfs            # Shared Directory
      swtpm           # TPM
      virglrenderer   # Virtual OpenGL
    ];
  };

  services = {                                # File Sharing
    gvfs.enable = true;
  };

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
}

#SHARED FOLDER
#FOR WINDOWS
# 3 options:
#
# 1. Make use of host samba server
# 1.0 Samba is installed by default. The network-shared folder is at /home/<user>/share.
# 1.1 On host, set a password for the autentication of the samba server
# 1.2 $ smbpasswd -a <user>
# 1.3 Give password twice
# 1.4 On windows, open file explorer, right click "This PC", Map network drive...
# 1.5 fill in address: \\<ip-address>\share
# 1.6 Log in with details entered beforehand
#
# 2. Since this setup make use of iommu, you can pass through external usb hard drives or a specific PCI storage devices
# 2.1 Open details of virtual desktop in virt-manager
# 2.2 Add hardware
# 2.3 USB Host Device
# 2.4 Select device and launch virtual desktop
#
# 3. Set up shared folders in windows guest that can be accessed by host
# 3.0. Enable above service gvfs (this is used in the file manager to actually connect to the windows directory)
# 3.1. Log in to Windows
# 3.2. Go to "Network and Sharing Center"
# 3.3. Click "Change advanced sharing settings" and enable all settings for Private, Guest or Public and All Networks
# 3.3.1. Under "All Networks" you can disable "Password protected sharing" but it seems for optimal use, it's better to still give the password in the file manager
# 3.4. (possibly optional), select a folder and click "Properties", "Sharing", "Advanced Sharing"
# 3.4.1. Enable "Share this file"
# 3.4.2. Under "Permissions", allow full control. Apply
# 3.5. Click "Share" and use de drop down to add "Everyone" and change "Permission Level" to "Read/Write". Share, Done
# 3.6. Search for services and open menu
# 3.6.1. Search for below serices. Right click and select "Properties". "Startup type" = Automatic
# 3.6.1.1. SSDP Discovery
# 3.6.1.2. uPnPDevice Host
# 3.6.1.3. Functions Discovery Provider Host
# 3.6.1.4. Functions Discovery Resource Publication
# 3.7. Find IP of virtual device and make sure you can ping it.
# 3.8. In file manager add connection
# 3.8.1. For example in PCManFM
# 3.8.2. Search for smb://*ip*/
# 3.8.3. You can even specify specific folder smb://*ip*/users/Matthias/Desktop/share
# 3.8.4. If prompted to log in, do it, otherwise it might close on its own.
# 3.9. If there are any issues, maybe disable firewall on guest
# 3.10. Recommended to bookmark location for later
# Note:
# There is no passthrough, its recommended to install the windows kvm guest drivers.
# Can be found on github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md
# Add this as CD storage in virt manager
# It can than be accest in the windows and the guest driver exe's can be run.
# Also, change video in virt-manager to virtio. This will fix the resolution
#
#FOR LINUX
# 2 options
#
# 1. Make use of host samba server
# 1.0 Samba is installed by default. The network-shared folder is at /home/<user>/share.
# 1.1 On host, set a password for the autentication of the samba server
# 1.2 $ smbpasswd -a <user>
# 1.3 Give password twice
# 1.4 On virtual machine open file manager
# 1.5 Search for smb://<ip-address>/share
# 1.6 Log in with details entered beforehand
#
# 2. Passing through a filesystem
# 2.1 Open details of virtual desktop on virt-manager
# 2.2 Add hardware
# 2.3 Select Filesystem: Type = mount / Mode = mapped / Source path = /home/<user>/share / Target path = /sharepoint
# 2.4 Boot into virtual machine
# 2.5 Create a directory to mount /sharepoint
# 2.6 $ sudo mount -t 9p -o trans=virtio /sharepoint /<mountpoint>

#SINGLE GPU PASSTHROUGH
# General Guide: gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/home
# 1. Download ISO
# 2. Download latest Video BIOS from techpowerup.com/vgabios
# 2.1. $ Sudo mkdir /var/lib/libvirt/vbios/
# 2.2. $ Sudo mv ~/Downloads/*.rom /var/lib/libvirt/vbios/GPU.rom
# 2.3. $ Cd /var/lib/libvirt/vbios/
# 2.4. $ Sudo chmod -R 660 GPU.rom
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

#MACOS ON VIRT-MANAGER
# General Guide: nixos.wiki/wiki/OSX-KVM
# Repository: github.com/kholia/OSX-KVM
# IMPORTANT: if you wish to start the virtual machine with virt-manager gui, clone to /home/<user>/.
# 1. git clone https://github.com/kholia/OSX-KVM
# 2. create a shell.nix (maybe best to store inside cloned directory)
# 3. shell.nix content:
#    with import <nixpkgs> {};
#    mkShell {
#      buildInputs = [
#        qemu
#        python3
#        iproute2
#      ];
#    }
# 4. In nixos configuration add:
#    virtualisation.libvirtd.enable = true;
#    users.extraUsers.<user>.extraGroups = [ "libvirtd" ];
#    boot.extraModprobeConfig = ''
#      options kvm_intel nested=1
#      options kvm_intel emulate_invalid_guest_state=0
#      options kvm ignore_msrs=1
#    '';
# 5. Run the shell: $ nix-shell
# 6. As mentioned in the README, run ./fetch-macOS.py
# 6.1 Can be a specific version
# 7. Create base image for the macOs installer
# 8. $ qemu-img convert BaseSystem.dmg -O raw BaseSystem.img
# 9. Create disk for macOS
# 9.1 $ qemu-img create -f qcow2 mac_hdd_ng.img 128G
# 10. Set up networking. If something like virbr0 does not get detected start virt-manager. Commands:
#    $ sudo ip tuntap add dev tap0 mode tap
#    $ sudo ip link set tap0 up promisc on
#    $ sudo ip link set dev virbr0 up
#    $ sudo ip link set dev tap0 master virbr0
# 11. Boot the system
# 11.1 $ ./OpenCore-Boot.sh
# 12. Choose the first option to start the MacOS installer: macOS Base Systen
# 12.1 Use Disk Utility to esase the correct drive.
# 13. Go back and select the option to reinstall macOS
# 13.1 After the initial installation, a reboot will happen. Do nothing and wait or select the second option 'MacOs install'.
# 13.2 This will finalize the installaton but it will probably reboot multiple times. The second option will now have changed to the name of your drive. Use this as the boot option
# 14. To add the installation to virt-manager:
# 14.1 $ sed "s/CHANGEME/$USER/g" macOS-libvirt-Catalina.xml > macOS.xml
# 14.2 Inside macOS.xml change the emulator from /usr/bin/qemu-system-x86_64 to /run/libvirt/nix-emulators/qemu-system-x86_64
# 14.3 $ virt-xml-validate macOS.xml
# 15. $ virsh --connect qemu:///system define macOS.xml
# 16.(optional if permission is needed to the libvirt-qemu user)
# 16.1 $ sudo setfacl -m u:libvirt-qemu:rx /home/$USER
# 16.2 $ sudo setfacl -R -m u:libvirt-qemu:rx /home/$USER/OSX-KVM
