#
# Bluetooth
#

{ pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    #hsphfpd.enable = true;         # HSP & HFP daemon
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
}
