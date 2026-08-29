{
  inputs,
  ...
}:

{
  flake.modules.darwin.base =
    { config, pkgs, ... }:
    {
      imports = [ inputs.sops-nix.darwinModules.sops ];

      sops = {
        defaultSopsFile = ../../secrets.yaml;
        validateSopsFiles = false;

        age = {
          sshKeyPaths = [ "/Users/${config.host.user.name}/.ssh/sops" ];
          keyFile = "/Users/${config.host.user.name}/.config/sops/age/keys.txt";
        };

        secrets = {
          llama-api = {
            owner = config.host.user.name;
            group = "staff";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        age
        sops
      ];

      home-manager = {
        users.${config.host.user.name} = {
          home.sessionVariables = {
            SOPS_AGE_KEY_FILE = config.sops.age.keyFile;
          };
        };
      };
    };
}
