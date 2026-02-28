{
  flake.modules.homeManager.emacs =
    { config, pkgs, ... }:
    {
      home.file.".emacs.d" = {
        source = pkgs.fetchFromGitHub {
          owner = "MatthiasBenaets";
          repo = "emacs.d";
          rev = "master";
          sha256 = "sha256-vCtfWJj+h6A5ePZA0n/hsJ7ueOuTo9/fQT8xjj05oEI=";
        };
        recursive = true;
      };

      services.emacs.enable = true;

      home.packages = with pkgs; [
        emacs
        emacs-all-the-icons-fonts
        fd
        ispell
        ripgrep
      ];
    };
}
