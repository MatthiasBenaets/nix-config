{
  flake.modules.homeManager.ubuntu =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          hello
        ];
      };
    };
}
