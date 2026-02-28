{
  flake.modules.nixos.base =
    { config, ... }:
    {
      system.stateVersion = config.host.state.version;
    };

  flake.modules.darwin.base =
    { config, ... }:
    {
      system.stateVersion = config.host.state.darwin;
    };
}
