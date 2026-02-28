{
  flake.modules.nixos.base = {
    services.gvfs.enable = true;
  };
}
