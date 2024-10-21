#
#  Specific system configuration settings for wsl
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./wsl
#   │        ├─ default.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ hyprland.nix
#           └─ ./virtualisation
#               └─ default.nix
#

{ pkgs, ... }:

{
  imports = [
      (fetchTarball {
      url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
      sha256 = "09j4kvsxw1d5dvnhbsgih0icbrxqv90nzf0b589rb5z6gnzwjnqf";
     }) ] ++
    (import ../../modules/desktops/virtualisation);

  wsl.enable = true;
  wsl.defaultUser = "nixos";


  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  hyprland.enable = true;

  programs.nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
      libraries = with pkgs; [
         stdenv.cc.cc.lib
         zlib
      ];
  };

  environment = {
    systemPackages = with pkgs; [
      # ansible # Automation
      #gmtp # Used for mounting gopro
      # plex-media-player # Media Player
      # simple-scan # Scanning
      # sshpass # Ansible Dependency
      # wacomtablet # Tablet
    ];
  };

}
