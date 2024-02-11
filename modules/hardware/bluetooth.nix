#
#  Bluetooth
#

{ pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        AutoEnable = true;
        ControllerMode = "bredr";
      };
    };
  };
  services.blueman.enable = true;
  systemd.user.services.mpris-proxy = {           # Media player controls
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };
}
