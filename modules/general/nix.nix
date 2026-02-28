{
  inputs,
  ...
}:

{
  flake.modules.nixos.base = {
    nix = {
      settings = {
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 2d";
      };
      registry.nixpkgs.flake = inputs.nixpkgs;
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs          = true
        keep-derivations      = true
      '';
    };
  };

  flake.modules.darwin.base = {
    nix = {
      gc = {
        automatic = true;
        interval.Day = 7;
        options = "--delete-older-than 7d";
      };
      extraOptions = ''
        # auto-optimise-store = true
        experimental-features = nix-command flakes
      '';
    };
  };
}
