{
  flake.modules.homeManager.pacman =
    { pkgs, ... }:
    {
      home = {
        packages = [
          pkgs.hello
        ];
      };
    };
}
