{
  flake.modules.nixos.work =
    {
      pkgs,
      ...
    }:
    {
      environment = {
        systemPackages = with pkgs; [
          ansible
          eduvpn-client
          libwacom
          R
          rstudio
          rclone # Gdrive ($ rclone config | rclone mount --daemon gdrive: <mount> | fusermount -u <mount>)
          sshpass
          syncthing
          vscode
        ];
      };
    };
}
