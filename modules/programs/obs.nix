{
  flake.modules.homeManager.obs =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          # advanced-scene-switcher
        ];
      };
    };
}
