{
  flake.modules.homeManager.ubuntu =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          claude-code
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
