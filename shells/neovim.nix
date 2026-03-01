{
  config,
  pkgs,
  ...
}:

{
  packages = with pkgs; [
    config.packages.neovim
    git
  ];
}
