{
  inputs,
  ...
}:

{
  flake.modules.nixos.base =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupCommand = "trash";
        extraSpecialArgs = {
          inherit (config) host;
          osConfig = config;
        };
        users.${config.host.user.name} = {
          home.stateVersion = config.host.state.version;

          programs = {
            home-manager.enable = true;
          };
        };
      };
    };

  flake.modules.darwin.base =
    { config, ... }:
    {
      imports = [
        inputs.home-manager.darwinModules.home-manager
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit (config) host;
          osConfig = config;
        };
        users.${config.host.user.name} = {
          home.stateVersion = config.host.state.version;
        };
      };
    };

  flake.modules.homeManager.base =
    {
      config,
      pkgs,
      host,
      ...
    }:
    {
      nix.package = pkgs.nix;
      home = {
        username = "${host.user.name}";
        homeDirectory = "/home/${host.user.name}";
        packages = [ pkgs.home-manager ];
        stateVersion = host.state.version;
      };
    };
}
