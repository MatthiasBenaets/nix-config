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

    activation = {                                      # Run script during rebuild/switch.
      linkDesktopApplications = {                       # Script that will add all packages to the system menu. Mainly tested on Gnome.
        after = [ "writeBoundary" "createXdgUserDirectories" ];
        before = [ ];
        data = ''
          rm -rf ${config.xdg.dataHome}/"applications/home-manager"
          mkdir -p ${config.xdg.dataHome}/"applications/home-manager"
          cp -Lr ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/"applications/home-manager/"
        '';
      };                                                # An alternative it adding ~$HOME/.nix-profile/share~ to XDG_DATA_DIRS, but I've noticed it sometimes does not work.
    };                                                  # XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS

    #file.".bash_aliases".text = ''
    #  alias alacritty="nixGLIntel ${pkgs.alacritty}/bin/alacritty"
    #'';                                                 # Aliases for packages that need openGL using nixGL. Change to your shell alias file. Note that home.shellAliases does not work...
  };

  programs = {                                          # Home-manager
    home-manager.enable = true;
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
