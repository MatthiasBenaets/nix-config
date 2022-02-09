{ pkgs, ... }:

{
  services = {
    polybar = {
      enable = true;
      script = ''
        polybar mybar &
      '';
      config = {
        "bar/mybar" = {
           modules-right = "date";
           tray-position = "right";
           tray-detached = "false";
        }; 
        "module/date" = {
           type = "internal/date";
           date = "%Y-%m-%d%";
        };
      };
    };
  };
}
