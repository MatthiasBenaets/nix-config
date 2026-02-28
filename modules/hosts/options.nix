{
  lib,
  ...
}:

with lib;
let
  hostOptions = {
    name = mkOption {
      type = types.str;
      example = "nixos";
      description = "Host name";
    };

    user.name = mkOption {
      type = types.str;
      example = "username";
      default = "matthias";
      description = "Host username";
    };

    state = mkOption {
      type = types.submodule {
        options = {
          version = mkOption {
            type = types.str;
            example = "22.05";
            description = "NixOS state version";

          };
          darwin = mkOption {
            type = types.int;
            example = 4;
            description = "Nix-Darwin state version";
          };
        };
      };
    };

    system = mkOption {
      type = types.str;
      example = "x86_64-linux";
      description = "System architecture";
    };

    monitors = mkOption {
      description = "List of monitors and their configurations";
      default = [ ];
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              default = "DP-1";
              description = "The name of the display interface";
            };
            w = mkOption {
              type = types.str;
              default = "1920";
              description = "Resolution width";
            };
            h = mkOption {
              type = types.str;
              default = "1080";
              description = "Resolution height";
            };
            refresh = mkOption {
              type = types.str;
              default = "60";
              description = "Refresh rate in Hz";
            };
            x = mkOption {
              type = types.str;
              default = "0";
              description = "X axis offset";
            };
            y = mkOption {
              type = types.str;
              default = "0";
              description = "Y axis offset";
            };
          };
        }
      );
    };

    shell = mkOption {
      type = types.str;
      example = "hyprland";
      description = "Graphical Shell";
    };
  };
in
{
  flake.modules.nixos.base = {
    options.host = hostOptions;
  };

  flake.modules.darwin.base = {
    options.host = hostOptions;
  };
}
