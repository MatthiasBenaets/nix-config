{
  flake.modules.nixos.base = {
    programs = {
      git = {
        enable = true;
      };
    };
  };
}
