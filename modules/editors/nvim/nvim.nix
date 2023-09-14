{ config, ... }:

let
  nixConfigDir = "${config.home.homeDirectory}/Git/nixos-config";
  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{
  # Config -------------------------------------------------------------------------
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${nixConfigDir}/modules/editors/nvim/LazyNvim";
}
