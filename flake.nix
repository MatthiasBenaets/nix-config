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
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; # Nix Packages (Default)
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Unstable Nix Packages
      nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

      # User Environment Manager
      home-manager = {
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Unstable User Environment Manager
      home-manager-unstable = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      # MacOS Package Management
      darwin = {
        url = "github:lnl7/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      # NUR Community Packages
      nur = {
        url = "github:nix-community/NUR";
        # Requires "nur.nixosModules.nur" to be added to the host modules
      };

      # Fixes OpenGL With Other Distros.
      nixgl = {
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Neovim
      nixvim = {
        url = "github:nix-community/nixvim/nixos-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Neovim
      nixvim-unstable = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      # Emacs Overlays
      emacs-overlay = {
        url = "github:nix-community/emacs-overlay";
        flake = false;
      };

      # Nix-Community Doom Emacs
      doom-emacs = {
        url = "github:nix-community/nix-doom-emacs";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.emacs-overlay.follows = "emacs-overlay";
      };

      # Official Hyprland Flake
      hyprland = {
        url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      };

      # Hyprlock
      hyprlock = {
        url = "github:hyprwm/hyprlock";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      # Hypridle
      hypridle = {
        url = "github:hyprwm/hypridle";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      # Hyprspace
      hyprspace = {
        url = "github:KZDKM/Hyprspace";
        inputs.hyprland.follows = "hyprland";
      };

      # KDE Plasma User Settings Generator
      plasma-manager = {
        url = "github:pjones/plasma-manager";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, home-manager-unstable, darwin, nur, nixgl, nixvim, nixvim-unstable, doom-emacs, hyprland, hyprlock, hypridle, hyprspace, plasma-manager, ... }: # Function telling flake which inputs to use
    let
      # Variables Used In Flake
      vars = {
        user = "matthias";
        location = "$HOME/.setup";
        terminal = "kitty";
        editor = "nvim";
      };
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable nixos-hardware home-manager nur nixvim doom-emacs hyprland hyprlock hypridle hyprspace plasma-manager vars; # Inherit inputs
        }
      );

      darwinConfigurations = (
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs-unstable home-manager-unstable darwin nixvim-unstable vars;
        }
      );

      homeConfigurations = (
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager nixgl vars;
        }
      );
    };
}
