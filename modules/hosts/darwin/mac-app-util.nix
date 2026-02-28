{
  inputs,
  ...
}:

{
  flake.modules.darwin.base =
    { config, ... }:
    {
      imports = [
        inputs.mac-app-util.darwinModules.default
      ];

      home-manager.sharedModules = [
        inputs.mac-app-util.homeManagerModules.default
      ];
    };
}
