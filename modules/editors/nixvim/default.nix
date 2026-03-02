{
  config,
  inputs,
  ...
}:

let
  nixvimConfig = pkgs: {
    enable = true;
    nixpkgs.pkgs = pkgs;
    imports = [ config.flake.modules.editors.nixvim ];
  };

  environment = pkgs: {
    systemPackages = with pkgs; [
      deno
      elixir
      erlang
      git
      go
      nodejs
      (python3.withPackages (
        ps: with ps; [
          pip
        ]
      ))
      ripgrep
      zig
    ];
    variables = {
      PATH = "$HOME/.npm-packages/bin:$PATH";
      NODE_PATH = "$HOME/.npm-packages/lib/node_modules:$NODE_PATH:";
    };
  };
in
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
      programs.nixvim = nixvimConfig pkgs;
      environment = environment pkgs;
    };

  flake.modules.darwin.nixvim =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixvim.nixDarwinModules.nixvim
      ];
      programs.nixvim = nixvimConfig pkgs;
      environment = environment pkgs;
    };
}
