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
      coreutils-full fzf ripgrep bat colordiff htop tree wget openssh diceware
      keychain watch jq starship git gcc gnumake gawk diffoscope tmate neofetch
      glow
    ];
  };
}
