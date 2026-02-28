{
  flake.modules.nixos.base =
    { config, ... }:
    {
      users.users.${config.host.user.name} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "video"
          "audio"
          "camera"
          "networkmanager"
          "lp"
          "scanner"
        ];
      };
    };
}
