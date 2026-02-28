{
  flake.modules.nixos.base = {
    services.envfs.enable = true;
  };
}
