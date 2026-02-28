{
  flake.modules.nixos.base =
    { config, pkgs, ... }:
    {
      virtualisation.docker.enable = true;

      users.groups.docker.members = [ "${config.host.user.name}" ];

      environment.systemPackages = with pkgs; [
        docker
        docker-compose
      ];
    };
}
