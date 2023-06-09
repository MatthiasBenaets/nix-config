{ pkgs, ... }:
with pkgs;

{
  home = {
    packages = with pkgs; [
      # Command-line tools
      go_1_20 git-crypt cargo yarn protobuf lima goreleaser vulnix
    ];
  };
}
