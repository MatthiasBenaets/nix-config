{ config, pkgs, lib, ... }: {

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.libvdpau-va-gl ]; #NVIDIA doesn't support libvdpau, so this package will redirect VDPAU calls to LIBVA.
  };

  environment.variables.VDPAU_DRIVER = "va_gl";
  environment.variables.LIBVA_DRIVER_NAME = "nvidia";
  environment.variables.NIXOS_OZONE_WL = "1";

# Configure keymap in X11
  services.xserver = {
  enable = true;
  layout = "us";
  xkbVariant = "";
  }; 
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  networking.hostName = "nixos"; # Define your hostname.

  # Configure keymap in X11
  services.xserver = {
    videoDrivers = ["nvidia"];
  };

  environment.sessionVariables = {
     WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "chaosinthecrd";

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
