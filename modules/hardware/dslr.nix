#
# DSLR Camera as webcam
#

{ config, lib, pkgs, fix, ... }:

{
  boot = {
    kernelModules = [ "v4l2loopback" ];           # Enable video for linux
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];  # Get latest version for current kernel
    extraModprobeConfig = ''
      alias dslr-webcam v4l2loopback
      options v4l2loopback exclusive_caps=1 max_buffers=2 card_label="Virtual Camera"
    '';                                           # Modprobe Module needed so camera can be detected as a device
  };

  environment = {
    systemPackages = [                 # Package dependencies
      pkgs.gphoto2
      fix.ffmpeg
      #shotwell
    ];
    interactiveShellInit = ''
      alias dslr='gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0'
    '';                                           # Alias for command to start video streaming the camera output
  };
}
