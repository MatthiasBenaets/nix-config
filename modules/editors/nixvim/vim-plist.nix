{
  flake.modules.editors.nixvim =
    { pkgs, ... }:
    {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          pname = "vim-plist";
          version = "60e69bec50dfca32f0a62ee2dacdfbe63fd92038";
          src = pkgs.fetchFromGitHub {
            owner = "darfink";
            repo = "vim-plist";
            rev = version;
            sha256 = "sha256-OIMXpX/3YXUsDsguY8/lyG5VXjTKB+k5XPfEFUSybng=";
          };
        })
      ];
    };
}
