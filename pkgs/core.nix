{ pkgs, ... }:
with pkgs;

{
  environment = {
    shells = with pkgs; [ zsh ];          # Default shell
    variables = {                         # System variables
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [ # the essential packages
      # Command-line tools
      neofetch
    ];
  };
}
