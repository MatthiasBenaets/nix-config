#
#  flake.nix *
#   ├─ ./hosts
#   │   └─ default.nix
#   ├─ ./darwin
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix
#

{
  description = "Nix, NixOS and Nix Darwin System Flake Configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages (Default)
      # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Unstable Nix Packages
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05"; # Unstable Nix Packages
      nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

      # User Environment Manager
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Unstable User Environment Manager
      # home-manager-unstable = {
      #   url = "github:nix-community/home-manager";
      #   inputs.nixpkgs.follows = "nixpkgs-unstable";
      # };

      # Stable User Environment Manager
      home-manager-stable = {
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs-stable";
      };

      # MacOS Package Management
      darwin = {
        url = "github:lnl7/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      #Nixos Windows Linux Subsystem
      nixos-wsl = {
        url = "github:nix-community/NixOS-WSL";
        # Requires nixos-wsl.nixosModules.default to be added to the host modules
      };

      # Fixes OpenGL With Other Distros.
      nixgl = {
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, home-manager-stable, darwin, nixgl, hyprland, hyprspace, plasma-manager, nixos-wsl, ... }: # Function telling flake which inputs to use
    let
      # Variables Used In Flake
      vars = {
        user = "nixos";
        location = "$HOME/.setup";
        terminal = "kitty";
        editor = "nano";
      };
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-stable nixos-hardware home-manager doom-emacs hyprland hyprspace plasma-manager nixos-wsl vars; # Inherit inputs
        }
      );

      darwinConfigurations = (
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-stable home-manager darwin vars;
        }
      );

      homeConfigurations = (
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-stable home-manager nixgl vars;
        }
      );
    };
}
