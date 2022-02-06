{ system, nixpkgs, home-manager }

{

  desktop = home-manager.lib.homeManagerConfiguration {
    inherit system nixpkgs home-manager;
    username = "matthias";
    homeDirectory = "/home/matthias";
    configuration = {
      imports = [
        ./desktop/home.nix
      ];
    };
  };

  laptop = home-manager.lib.homeManagerConfiguration {
   inherit system nixpkgs home-manager;
    username = "matthias";
    homeDirectory = "/home/matthias";
    configuration = {
      imports = [
        ./laptop/home.nix
      ];
    };
  };

}
