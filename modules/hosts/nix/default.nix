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
          (import inputs.nixgl { inherit pkgs; }).nixGLIntel # OpenGL for GUI apps
          #.nixVulkanIntel
        ];

        # Example
        # file.".bash_aliases".text = ''
        #   alias alacritty="nixGLIntel ${pkgs.alacritty}/bin/alacritty"
        # ''; # Aliases for package using openGL (nixGL). home.shellAliases does not work

        activation = {
          linkDesktopApplications = {
            # Add Packages To System Menu by updating database
            after = [
              "writeBoundary"
              "createXdgUserDirectories"
            ];
            before = [ ];
            data = "sudo /usr/bin/update-desktop-database";
          };
        };
      };
    };
}
