{
  flake.modules.homeManager.ubuntu =
    { pkgs, ... }:
    {
      home = {
        packages = [
          pkgs.hello
        ];
      };
    };
}
