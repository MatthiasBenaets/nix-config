{ pkgs, ... }:
with pkgs;

{

  home = {
    packages = with pkgs; [
      # Terminal
      coreutils fzf ripgrep bat htop tree wget keychain watch jq starship
      gcc gnumake gawk
      # coreutils fzf ripgrep bat colordiff htop tree wget openssh diceware
      # keychain watch jq starship git gcc gnumake gawk diffoscope tmate neofetch
      # glow
    ];
  };
  
}
