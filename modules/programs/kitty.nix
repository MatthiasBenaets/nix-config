{ config, ... }:

let
  nixConfigDir = "${config.home.homeDirectory}/Git/nixos-config";
  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{
  xdg.configFile."kitty".source = mkOutOfStoreSymlink "${nixConfigDir}/darwin/modules/kitty/kitty.conf";
}
