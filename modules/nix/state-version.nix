{
  flake.modules.nixos.base =
    { config, ... }:
    {
      system.stateVersion = config.host.state.version;
    };
}
