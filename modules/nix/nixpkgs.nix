{ withSystem, ... }:

{
  flake.modules.nixos.base =
    { config, ... }:
    {
      nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs);
      nixpkgs.hostPlatform = config.host.system;
    };
}
