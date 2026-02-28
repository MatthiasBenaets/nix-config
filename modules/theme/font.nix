{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      fonts = {
        packages = with pkgs; [
          carlito
          vegur
          source-code-pro
          # jetbrains-mono
          font-awesome
          corefonts
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-color-emoji
          nerd-fonts.fira-code
        ];
      };
    };
}
