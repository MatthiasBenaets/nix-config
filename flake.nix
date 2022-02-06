{
  description = "Personal NixOS/Home-Manager Configuration";

  inputs =
    {
      # Nix Packages
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

      # Nix User Packages
  #   nurpkgs = {
  #     url = github:nix-community/NUR;
  #     inputs.nixpkgs.follows = "nixpkgs";
  #   };

      # Home Package Management
      home-manager = {
        url = github:nix-community/home-manager;
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: #add nurpkgs
    let
      system = "x86_64-linux";
      
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs system home-manager;
        }
      );

      #devShell.${system} = (
      #  import ./outputs/installation.nix {
      #    inherit system nixpkgs;
      #  }
      #);
    };
}
