{
  pkgs,
  ...
}:

let
  mkShell =
    {
      packages ? [ ],
      env ? { },
      shellHook ? "",
    }:
    pkgs.mkShell {
      packages = packages;
      env = env;
      shellHook = shellHook;
    };
in
{
  default = mkShell {
    packages = with pkgs; [
      vim
      git
    ];
  };
}
