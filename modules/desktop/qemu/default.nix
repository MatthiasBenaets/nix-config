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
  environment = {
    systemPackages = with pkgs; [
      virt-manager
    ];
  };

  virtualisation = {
    libvirtd.enable = true;                   # Virtual drivers
    spiceUSBRedirection.enable = true;        # USB passthrough
  };
}
