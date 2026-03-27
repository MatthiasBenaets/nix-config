{
  flake.modules.homeManager.ubuntu =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          hello
        ];
      };
    };
}

# Native
# - chrome
# - docker
# - firefox
# - gnome-browser-connector
#   - Forge
# - gnome-tweaks
