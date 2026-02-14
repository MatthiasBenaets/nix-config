{ inputs, pkgs, vars, ... }:

{
  home = {
    packages = [
      (import inputs.nixgl { inherit pkgs; }).nixGLIntel # OpenGL for GUI apps
      #.nixVulkanIntel
      pkgs.hello
    ];

    # file.".bash_aliases".text = ''
    #   alias alacritty="nixGLIntel ${pkgs.alacritty}/bin/alacritty"
    # ''; # Aliases for package using openGL (nixGL). home.shellAliases does not work

    activation = {
      linkDesktopApplications = {
        # Add Packages To System Menu by updating database
        after = [ "writeBoundary" "createXdgUserDirectories" ];
        before = [ ];
        data = "sudo /usr/bin/update-desktop-database";
      };
    };
  };

  xdg = {
    enable = true;
    systemDirs.data = [ "/home/${vars.user}/.nix-profile/share" ];
  }; # Add Nix Packages to XDG_DATA_DIRS

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;
}
