{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs = {
        thunar = {
          enable = true;
          plugins = with pkgs; [
            thunar-archive-plugin
            thunar-volman
            thunar-media-tags-plugin
          ];
        };
      };

      services = {
        tumbler.enable = true;
      };
    };
}
