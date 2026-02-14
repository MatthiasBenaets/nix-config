{
  description = "Nix, NixOS and Nix Darwin System Flake Configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
      nixos-hardware.url = "github:nixos/nixos-hardware/master";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      darwin = {
        url = "github:lnl7/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nur.url = "github:nix-community/NUR";
      nixgl.url = "github:guibou/nixGL";
      nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      emacs-overlay = {
        url = "github:nix-community/emacs-overlay";
        flake = false;
      };
      doom-emacs = {
        url = "github:nix-community/nix-doom-emacs";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.emacs-overlay.follows = "emacs-overlay";
      };
      hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      plasma-manager = {
        url = "github:pjones/plasma-manager";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "nixpkgs";
      };
      mac-app-util.url = "github:hraban/mac-app-util";
    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, darwin, nur, nixgl, nixvim, doom-emacs, hyprland, plasma-manager, mac-app-util, ... }: # Function telling flake which inputs to use
    let
      overlays = [
        (import ./overlays/stable.nix { inherit inputs; })
      ];

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
          description = "NixOS configurations";
          inherit (nixpkgs) lib;
          inherit inputs overlays vars;
        }
      );

      darwinConfigurations = (
        import ./darwin {
          description = "MacOS configurations";
          inherit (nixpkgs) lib;
          inherit inputs overlays vars;
        }
      );

      homeConfigurations = (
        import ./nix {
          description = "Nix configurations";
          inherit (nixpkgs) lib;
          inherit inputs overlays vars;
        }
      );
    };
}
