{ lib, inputs, nixpkgs, home-manager, nixgl, user, ... }:

{
  pacman = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    system = "x86_64-linux";
    username = "${user}";
    homeDirectory = "/home/${user}";
    configuration = import ./pacman.nix;
    extraSpecialArgs = { inherit inputs nixgl user; };
  };
}
