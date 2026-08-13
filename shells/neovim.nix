{
  config,
  pkgs,
  ...
}:

{
  packages = [
    config.packages.neovim
    pkgs.opencode
  ];
}
