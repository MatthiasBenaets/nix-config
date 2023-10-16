#
#  Flatpak
#  Very janky way of declaring all packages used
#  Might cause issues on new system installs
#  Only use when you know what you're doing
#

{ config, lib, pkgs,...}:

with lib;
{
  options = {
    flatpak = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      extraPackages = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };
  };

  config = mkIf (config.flatpak.enable)
  {
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.flatpak.enable = true;

    system.activationScripts =
      let
        extraPackages = concatStringsSep " " config.flatpak.extraPackages;
      in mkIf (config.flatpak.extraPackages != [])
      {
      flatpak.text =
        ''
          flatpaks=(
            ${extraPackages}
          )

          ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

          for package in ''${flatpaks[*]}; do
            check=$(${pkgs.flatpak}/bin/flatpak list --app | ${pkgs.gnugrep}/bin/grep $package)
            if [[ -z "$check" ]] then
              ${pkgs.flatpak}/bin/flatpak install -y flathub $package
            fi
          done

          installed=($(${pkgs.flatpak}/bin/flatpak list --app | ${pkgs.gawk}/bin/awk -F$'\t*' '{$1=$3=$4=$5=""; print $0}'))

          for remove in ''${installed[*]}; do
            if [[ ! " ''${flatpaks[*]} " =~ " ''${remove} " ]]; then
              ${pkgs.flatpak}/bin/flatpak uninstall -y $remove
              ${pkgs.flatpak}/bin/flatpak uninstall -y --unused
            fi
          done
        '';
      };
  };
}
