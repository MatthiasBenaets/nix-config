{ lib, inputs, system, ... }:

{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./desktop
      ./configuration.nix
    ];
  };

# laptop = lib.nixosSystem {
#   inherit system;
#   specialArgs = { inherit inputs; };
#   modules = [
#     ./laptop/configuration.nix
#     ./laptop/hardware-configuration.nix
#
#     home-manager.nixosModules.home-manager {
#       home-manager.useGlobalPkgs = true;
#       home-manager.useUserPackages = true;
#       home-manager.users.matthias = import ./laptop/home.nix;
#     }
#   ];
# };
}
