#
#  Specific system configuration settings for wsl
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./wsl
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ hyprland.nix
#           └─ ./virtualisation
#               └─ default.nix
#

{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix
      (fetchTarball {
      url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
      sha256 = "1rq8mrlmbzpcbv9ys0x88alw30ks70jlmvnfr2j8v830yy5wvw7h";
     }) ] ++
    (import ../../modules/desktops/virtualisation);

    wsl.enable = true;
    wsl.defaultUser = "nixos";
  # boot = {
  #   loader = {
  #     systemd-boot = {
  #       enable = true;
  #       configurationLimit = 5;
  #     };
  #     efi.canTouchEfiVariables = true;
  #     timeout = 1;
  #   };
  #   initrd.kernelModules = [ "amdgpu" ];
  # };

  # hardware = {
  #   graphics = {
  #     enable = true;
  #     extraPackages = with pkgs; [
  #       intel-media-driver
  #       vaapiIntel
  #       rocm-opencl-icd
  #       rocm-opencl-runtime
  #       amdvlk
  #     ];
  #     extraPackages32 = with pkgs; [
  #       driversi686Linux.amdvlk
  #     ];
  #     driSupport = true;
  #     driSupport32Bit = true;
  #   };
  #   sane = {
  #     enable = true;
  #     extraBackends = [ pkgs.sane-airscan ];
  #   };
  # };

  hyprland.enable = true;

  environment = {
    systemPackages = with pkgs; [
      # ansible # Automation
      #gmtp # Used for mounting gopro
      # plex-media-player # Media Player
      # simple-scan # Scanning
      # sshpass # Ansible Dependency
      # wacomtablet # Tablet
    ];
  };

  flatpak = {
    extraPackages = [
      "com.github.tchx84.Flatseal"
    ];
  };
}
