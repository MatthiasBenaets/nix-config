{
  config,
  pkgs,
  ...
}:

{
  default = pkgs.mkShell {
    packages = with pkgs; [
      vim
      git
    ];
  };

  neovim = pkgs.mkShell (import ./neovim.nix { inherit config pkgs; });

  python = pkgs.mkShell (import ./python.nix { inherit pkgs; });

  nodejs = pkgs.mkShell (import ./nodejs.nix { inherit pkgs; });
}
