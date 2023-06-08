{ pkgs, ... }:
with pkgs;

{
  environment = {
    systemPackages = with pkgs; [         # Installed Nix packages
      # Command-line tools
      go_1_20 git-crypt cargo yarn protobuf lima goreleaser vulnix
    ];
  };
}
