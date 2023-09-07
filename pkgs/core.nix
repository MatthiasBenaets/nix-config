{ pkgs, ... }:
with pkgs;

{

  home = {
    packages = with pkgs; [
      # Terminal
      coreutils-full fzf ripgrep bat colordiff htop tree wget openssh diceware
      keychain watch jq starship git gcc gnumake gawk diffoscope tmate neofetch
      glow step-ca
    ];
  };
  
}
