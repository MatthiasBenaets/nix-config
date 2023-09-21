#
#  DSLR Camera as webcam
#

{ config, lib, pkgs, ... }:

{
  boot = {
    kernelModules = [ "v4l2loopback" ];           # Enable Video 4 Linux
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];
    extraModprobeConfig = ''
      alias dslr-webcam v4l2loopback
      options v4l2loopback exclusive_caps=1 max_buffers=2 card_label="Virtual Camera"
    '';                                           # Modprobe Module to Detect Device
  };

  environment = {
    systemPackages = with pkgs; [                 # Package Dependencies
      gphoto2
      ffmpeg-full
    ];
    interactiveShellInit = ''
      alias dslr='gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0'
    '';                                           # Start Command Alias
  };
}
