#
# Nix setup using Home-manager
#
# flake.nix
#   └─ ./nix
#       ├─ default.nix
#       └─ pacman.nix *
#

{ config, pkgs, inputs, nixgl, user, ... }:

{
  home = {
    packages = [
      (import nixgl { inherit pkgs; }).nixGLIntel       # OpenGL for GUI apps. Add to aliases is recommended.
                                     #.nixVulkanIntel
      pkgs.hello
      pkgs.emacs
    ];

    #file.".bash_aliases".text = ''
    #  alias alacritty="nixGLIntel ${pkgs.alacritty}/bin/alacritty"
    #'';                                                 # Aliases for packages that need openGL using nixGL. Change to your shell alias file. Note that home.shellAliases does not work...

    activation = {                                      # Run script during rebuild/switch.
      linkDesktopApplications = {                       # Script that will add all packages to the system menu. (Mainly tested on Gnome)
        after = [ "writeBoundary" "createXdgUserDirectories" ];
        before = [ ];
        data = "sudo /usr/bin/update-desktop-database"; # This will update the database, requires sudo. Not recommended to install via home-manager so do it manually for your distro.
      };
    };
  };

  xdg = {
    enable = true;
    systemDirs.data = [ "/home/${user}/.nix-profile/share" ]; # Will add nix packages to XDG_DATA_DIRS and thus accessible from the menus.
  };

  nix = {                                               # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;                       # Optimise syslinks
    };
    package = pkgs.nixFlakes;                           # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;                    # Allow proprietary software.
}
