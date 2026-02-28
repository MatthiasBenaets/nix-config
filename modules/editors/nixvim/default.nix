{
  config,
  inputs,
  ...
}:
{
  perSystem =
    { inputs', pkgs, ... }:
    {
      packages.neovim = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
        inherit pkgs;
        module = config.flake.modules.editors.nixvim;
      };
    };

  flake.modules.nixos.nixvim =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixvim.nixosModules.nixvim
      ];
      programs.nixvim = {
        enable = true;
        nixpkgs.pkgs = pkgs;
        imports = [ config.flake.modules.editors.nixvim ];
      };
    };
}
