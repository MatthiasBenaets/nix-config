{ lib, inputs, system, home-manager, ... }:

{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.matthias = import ./desktop/home.nix;
      }
    ];
  };

 laptop = lib.nixosSystem {
   inherit system;
   specialArgs = { inherit inputs; };
   modules = [
     ./laptop
     ./configuration.nix

     home-manager.nixosModules.home-manager {
       home-manager.useGlobalPkgs = true;
       home-manager.useUserPackages = true;
       home-manager.users.matthias = import ./laptop/home.nix;
     }
   ];
 };
}
