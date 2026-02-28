{
  flake.modules.nixos.base = {
    security.polkit.enable = true;
  };
}
