{
  flake.modules.darwin.omniwm =
    { config, pkgs, ... }:
    {
      homebrew = {
        enable = true;
        casks = [
          "BarutSRB/tap/omniwm"
        ];
      };
    };
}
