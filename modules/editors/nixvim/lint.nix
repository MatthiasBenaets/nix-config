{
  flake.modules.editors.nixvim =
    { pkgs, ... }:
    {
      extraPackages = with pkgs; [
        eslint_d
      ];

      plugins = {
        lint = {
          enable = true;
          lintersByFt = {
            javascript = [ "eslint_d" ];
            typescript = [ "eslint_d" ];
            svelte = [ "eslint_d" ];
            python = [ "pylint" ];
          };
        };
      };
    };
}
