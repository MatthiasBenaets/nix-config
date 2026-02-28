{
  flake.modules.nixos.base = {
    programs.direnv = {
      enable = true;
      loadInNixShell = true;
      nix-direnv.enable = true;
    };
  };
}
