{
  flake.modules.nixos.base = {
    programs.nix-ld = {
      enable = true;
      libraries = [ ];
    };
  };
}
