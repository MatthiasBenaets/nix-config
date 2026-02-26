{
  flake.modules.editors.nixvim =
    { pkgs, ... }:
    {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          pname = "vim-monkey-c";
          version = "2b3b5df632c4d056c0a9975cf7efed72bf0950cb";
          src = pkgs.fetchFromGitHub {
            owner = "klimeryk";
            repo = "vim-monkey-c";
            rev = version;
            sha256 = "sha256-DVSxJHNrNCxQJNRJqwo6hxLjx22Qe2mWHcmfhFmPTOg=";
          };
        })
      ];
    };
}
