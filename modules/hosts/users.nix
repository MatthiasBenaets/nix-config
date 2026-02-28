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

  flake.modules.darwin.base =
    { config, ... }:
    {
      users.users.${config.host.user.name} = {
        home = "/Users/${config.host.user.name}";
      };

      system.primaryUser = config.host.user.name;
    };
}
