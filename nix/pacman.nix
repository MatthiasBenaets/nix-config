#
#  Nix Setup using Home-manager
#
#  flake.nix
#   └─ ./nix
#       ├─ default.nix
#       └─ pacman.nix *
#

{ config, inputs, pkgs, nixgl, vars, ... }:

{
  home = {
    packages = [
      (import nixgl { inherit pkgs; }).nixGLIntel       # OpenGL for GUI apps
                                     #.nixVulkanIntel
      pkgs.hello
    ];

    #file.".bash_aliases".text = ''
    #  alias alacritty="nixGLIntel ${pkgs.alacritty}/bin/alacritty"
    #'';                                                # Aliases for package using openGL (nixGL). home.shellAliases does not work

    activation = {                                      # Rebuild Script
      linkDesktopApplications = {                       # Add Packages To System Menu
        after = [ "writeBoundary" "createXdgUserDirectories" ];
        before = [ ];
        data = "sudo /usr/bin/update-desktop-database"; # Updates Database
      };
    };
  };

  xdg = {                                               # Add Nix Packages to XDG_DATA_DIRS
    enable = true;
    systemDirs.data = [ "/home/${vars.user}/.nix-profile/share" ];
  };

  nix = {                                               # Nix Package Manager Settings
    settings ={
      auto-optimise-store = true;
    };
    package = pkgs.nixFlakes;                           # Enable Flakes
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;                    # Allow Proprietary Software.
}
