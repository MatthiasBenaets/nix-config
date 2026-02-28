let
  settings = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
  };
in
{
  flake.modules.nixos.base = {
    programs.direnv = settings;
  };

  flake.modules.darwin.base = {
    programs.direnv = settings;
  };
}
