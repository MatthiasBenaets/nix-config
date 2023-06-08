{ config, ... }:

let
  nixConfigDir = "${config.home.homeDirectory}/Git/nixos-config";
  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{
  # Config and widgets ------------------------------------------------------------------------- {{{
  xdg.configFile."skhd".source = mkOutOfStoreSymlink "${nixConfigDir}/darwin/modules/skhd/config";
}
