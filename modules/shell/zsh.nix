# taken from https://github.com/aywrite/nix-config
{ pkgs, ... }:
let
  # this idea is from https://github.com/BrianHicks/dotfiles.nix/blob/master/dotfiles/zsh.nix
  extras = [
    ./zshrc
    ./shell_exports
    ./shell_aliases
    ./shell_functions
  ];
  extraInitExtra = builtins.foldl' (soFar: new: soFar + "\n" + builtins.readFile new) "" extras;
in
{
  # .zshenv
  programs.zsh = {
    enable = true;
    # enableAutosuggestions = false;
    enableCompletion = false;
    shellAliases = {
      cls = "clear";
    };

    initExtra = ''
      # Display red dots while waiting for completion
      COMPLETION_WAITING_DOTS="true"
    '' + extraInitExtra;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git" "z"
      ];
    };

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.6.0";
          sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
        };
      }
    ];
  };
}
