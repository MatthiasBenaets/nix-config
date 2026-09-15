{
  flake.modules.editors.nixvim =
    { pkgs, ... }:
    {
      colorschemes.tokyonight = {
        enable = true;
        settings = {
          style = "night";
          transparent = true;
        };
      };
    };
}
