{ config, pkgs, lib, ... }: 
let
  # GTX 1660 Super
  gpuIDs = [
    "10de:21c4"
    "10de:1aeb"
    "10de:1aec"
    "10de:1aed"
  ];
in 
{

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    #extraPackages = with pkgs; [nvidia-vaapi-driver]; #NVIDIA doesn't support libvdpau, so this package will redirect VDPAU calls to LIBVA.
  };

  environment = {
    variables = {
      # GBM_BACKEND = "nvidia-drm";
      # LIBVA_DRIVER_NAME = "nvidia";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0"; # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid having problems on some games.
      XCURSOR_THEME = "Bibita-Modern-Ice";
      XCURSOR_SIZE = "24";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
  };

# Configure keymap in X11
  services.xserver = {
  enable = true;
  layout = "us";
  xkbVariant = "";
  };

  #hardware.nvidia = {
  #  modesetting.enable = true;
  #  powerManagement.enable = false;
  #  powerManagement.finegrained = false;
  #  open = true;
  #  nvidiaSettings = true;
  #  package = config.boot.kernelPackages.nvidiaPackages.stable;
  #};

  boot.kernelModules = ["vfio-pci" "kvm-amd"];
  boot.initrd.availableKernelModules = [ 
    "amdgpu"
  ];
  boot.extraModprobeConfig="options vfio-pci ids=10de:21c4,10de:1aeb,10de:1aec,10de:1aed";

  boot.blacklistedKernelModules = ["nouveau" "nvidiafb" "nvidia" "nvidia-uvm" "nvidia-drm" "nvidia-modeset"];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ 
  "amd_iommu=on"
  "video=efifb:off"
  ];

  networking.hostName = "nixos"; # Define your hostname.

  # Configure keymap in X11
  services.xserver = {
    videoDrivers = ["amdgpu"];
  };

  environment.sessionVariables = {
     #WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "chaosinthecrd";
  users.groups.libvirtd.members = [ "root" "chaosinthecrd"];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     cmake
     neovim
     kitty
     firefox
     waybar
  ];

}
