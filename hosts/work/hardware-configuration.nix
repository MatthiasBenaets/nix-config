#
# Hardware settings for Lenovo Thinkpad T15 Gen1 15.6" Laptop
# Dual boot active. Windows @ sda2 / NixOS @ sda4
#
# flake.nix
#  └─ ./hosts
#      └─ ./work
#          ├─ default.nix
#          └─ hardware-configuration.nix *
#
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
#

{ config, lib, modulesPath, host, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/c44a8f5c-1b8e-4c0d-aa63-755a95bd5a50";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/A101-6404";
      fsType = "vfat";
    };

  fileSystems."/windows" =
    {
      device = "/dev/disk/by-uuid/01D9316EDB06F490";
      fsType = "ntfs";
      options = [ "nofail" "uid=1000" "gid=100" ];
    };

  swapDevices = [ ];

  networking = with host; {
    useDHCP = lib.mkDefault true;
    hostName = hostName;
    enableIPv6 = false;
    networkmanager.enable = true;
    networkmanager.wifi.scanRandMacAddress = false;
    firewall = {
      # wireguard trips rpfilter up
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
      # If packets are still dropped, they will show up in dmesg
      logReversePathDrops = true;
      # To load wireguard cert in nm-applet: nmcli connection import type wireguard file <config file>
    };
    bridges = {
      "br0" = {
        interfaces = [ "enp0s31f6" ];
      };
    };
    interfaces = {
      #enp0s31f6.useDHCP = lib.mkDefault true;
      #wlp0s20f3.useDHCP = lib.mkDefault true;
      br0.useDHCP = true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
