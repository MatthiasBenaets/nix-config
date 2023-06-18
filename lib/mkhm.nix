name: { pkgs, lib, home-manager, user }:

  home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit lib pkgs user; };
    modules = [
      ../users/chaosinthecrd/home-manager.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          packages = [ pkgs.home-manager ];
          stateVersion = "23.05";
        };
      }
    ];
  }
