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
          home = {
            stateVersion = config.host.state.version;
          };

          programs = {
            home-manager.enable = true;
          };
        };
      };
    };
}
