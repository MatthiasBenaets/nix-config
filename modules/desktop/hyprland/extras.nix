{ config, ... }:

let
  nixConfigDir = "${config.home.homeDirectory}/Git/nixos-config";
  inherit (config.lib.file) mkOutOfStoreSymlink;
in

{
  # Config and widgets ------------------------------------------------------------------------- {{{
  xdg.configFile."wpaperd".source = mkOutOfStoreSymlink "${nixConfigDir}/modules/desktop/hyprland/wpaperd";
  xdg.configFile."waybar".source = mkOutOfStoreSymlink "${nixConfigDir}/modules/desktop/hyprland/waybar";
  xdg.configFile."swww".source = mkOutOfStoreSymlink "${nixConfigDir}/modules/desktop/hyprland/swww";
  xdg.configFile."rofi".source = mkOutOfStoreSymlink "${nixConfigDir}/modules/desktop/hyprland/rofi";
  xdg.configFile."dolphinrc".source = mkOutOfStoreSymlink "${nixConfigDir}/modules/desktop/hyprland/dolphin/dolphinrc";
}
