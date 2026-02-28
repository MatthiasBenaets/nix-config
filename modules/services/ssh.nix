{
  flake.modules.nixos.base = {
    services = {
      openssh = {
        enable = true;
        allowSFTP = true;
        extraConfig = ''
          HostKeyAlgorithms +ssh-rsa
        '';
      };
    };

    programs.ssh.extraConfig = ''
      Host *
        SetEnv TERM=xterm-256color
    '';
  };
}
