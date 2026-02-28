{
  flake.modules.nixos.virtualisation =
    { config, pkgs, ... }:
    {
      boot.extraModprobeConfig = ''
        options kvm_intel nested=1
        options kvm_intel emulate_invalid_guest_state=0
        options kvm ignore_nsrs=1
      '';

      users.groups = {
        libvirtd.members = [
          "root"
          "${config.host.user.name}"
        ];
        kvm.members = [
          "root"
          "${config.host.user.name}"
        ];
      };

      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;
          };
        };
        spiceUSBRedirection.enable = true;
      };

      programs.virt-manager.enable = true;

      environment = {
        systemPackages = with pkgs; [
          virt-manager
          virt-viewer
          qemu
          OVMF
          gvfs
          swtpm
          virglrenderer
        ];
      };

      services = {
        gvfs.enable = true;
      };
    };
}
