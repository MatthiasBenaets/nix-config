{
  config,
  inputs,
  ...
}:

let
  nixvimConfig = pkgs: host: osConfig: {
    enable = true;
    nixpkgs.pkgs = pkgs;
    _module.args = {
      inherit host osConfig;
    };
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
        module = {
          imports = [ config.flake.modules.editors.nixvim ];
          _module.args = {
            host = {
              name = "default";
            };
            osConfig = null;
          };
        };
      };
    };

  flake.modules.nixos.nixvim =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.nixvim.nixosModules.nixvim
      ];
      programs.nixvim = nixvimConfig pkgs config.host config;
      environment.systemPackages = packages pkgs;
      home-manager.users.${config.host.user.name} = {
        imports = [ npmEnvironment ];
      };
    };

  flake.modules.homeManager.nixvim =
    {
      config,
      host,
      osConfig ? null,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.nixvim.homeModules.nixvim
        npmEnvironment
      ];
      programs.nixvim = nixvimConfig pkgs host osConfig;
      home.packages = packages pkgs;
    };

  flake.modules.darwin.nixvim =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.nixvim.nixDarwinModules.nixvim
      ];
      programs.nixvim = nixvimConfig pkgs config.host config;
      environment.systemPackages = packages pkgs;
      home-manager.users.${config.host.user.name} = {
        imports = [ npmEnvironment ];
      };
    };
}
