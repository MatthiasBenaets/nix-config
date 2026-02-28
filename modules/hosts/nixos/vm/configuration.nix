{
  flake.modules.nixos.vm =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          hello
        ];
      };
    };
}
