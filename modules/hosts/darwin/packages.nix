{
  flake.modules.darwin.base =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          eza
          git
          iperf3
          mas
          ranger
          tldr
          wget
          zsh-powerlevel10k
        ];
      };
    };
}
