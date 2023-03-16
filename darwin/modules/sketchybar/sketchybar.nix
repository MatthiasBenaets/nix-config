{ config, ... }:

let
  nixConfigDir = "${config.home.homeDirectory}/Git/nixos-config";
  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{
  # Config and widgets ------------------------------------------------------------------------- {{{
  xdg.configFile."sketchybar".source = mkOutOfStoreSymlink "${nixConfigDir}/darwin/modules/sketchybar/config";
}
