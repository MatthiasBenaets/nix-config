#
#  Flatpak
#  Janky way of declaring all packages
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
    xdg.portal.enable = true;
    xdg.portal.extraPortals = mkIf (config.wlwm.enable || config.x11wm.enable) [
      pkgs.xdg-desktop-portal-gtk
    ];

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

          # for package in ''${flatpaks[*]}; do

          for package in ''${flatpaks[@]}; do
            if ! ${pkgs.flatpak}/bin/flatpak list --app | grep -q "$package"; then
              ${pkgs.flatpak}/bin/flatpak install -y flathub $package
            fi
          done

          installed=($(${pkgs.flatpak}/bin/flatpak list --app --columns=application | tail -n +1))

          for remove in ''${installed[@]}; do
            found=false
            for package in ''${flatpaks[@]}; do
              if [[ "$remove" == "$package"* ]]; then
                found=true
                break
              fi
            done

            if [[ "$found" == false ]]; then
              ${pkgs.flatpak}/bin/flatpak uninstall -y "$remove"
              ${pkgs.flatpak}/bin/flatpak uninstall -y --unused
            fi
          done
        '';
      };
  };
}
