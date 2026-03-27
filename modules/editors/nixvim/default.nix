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

  packages =
    pkgs: with pkgs; [
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

  npmEnvironment =
    { config, ... }:
    {
      home.file.".npmrc".text = ''
        prefix=${config.home.homeDirectory}/.npm-packages
      '';

      home.sessionPath = [
        "${config.home.homeDirectory}/.npm-packages/bin"
      ];

      home.sessionVariables = {
        PATH = "${config.home.homeDirectory}/.npm-packages/bin:$PATH";
        NODE_PATH = "${config.home.homeDirectory}/.npm-packages/lib/node_modules:$NODE_PATH:";
        EDITOR = "nvim";
        VISUAL = "nvim";
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
      environment.packages = packages pkgs;
      home-manager.users.${config.host.user.name} = {
        imports = [ npmEnvironment ];
      };
    };

  flake.modules.homeManager.nixvim =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.nixvim.homeModules.nixvim
        npmEnvironment
      ];
      programs.nixvim = nixvimConfig pkgs;
      home.packages = packages pkgs;
    };

  flake.modules.darwin.nixvim =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixvim.nixDarwinModules.nixvim
      ];
      programs.nixvim = nixvimConfig pkgs;
      environment.packages = packages pkgs;
      home-manager.users.${config.host.user.name} = {
        imports = [ npmEnvironment ];
      };
    };
}
