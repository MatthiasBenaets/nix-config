{
  inputs,
  ...
}:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {

      home = {
        packages = [
          inputs.nixgl.packages.${pkgs.stdenv.hostPlatform.system}.nixGLDefault # nixGL will infer the correct nixGL package. The --impure flag will be required during switch command.
          # Specifying a specific nixGL package will not require the impure flag.
        ];

        activation = {
          linkDesktopApplications = {
            # Add Packages To System Menu by updating database (might require relogging)
            after = [
              "writeBoundary"
              "createXdgUserDirectories"
            ];
            before = [ ];
            data = "/usr/bin/sudo /usr/bin/update-desktop-database";
          };
        };
      };
    };
}
