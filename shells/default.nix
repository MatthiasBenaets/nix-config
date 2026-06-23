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

  pandoc = pkgs.mkShell (import ./pandoc.nix { inherit config pkgs; });

  python = pkgs.mkShell (import ./python.nix { inherit pkgs; });

  neovim = pkgs.mkShell (import ./neovim.nix { inherit config pkgs; });

  nodejs = pkgs.mkShell (import ./nodejs.nix { inherit pkgs; });
}
