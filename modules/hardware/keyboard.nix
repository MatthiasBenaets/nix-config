# Simulate apple keyboard
{
  boot.extraModprobeConfig = "options hid_apple fnmode=1";

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            leftmeta = "overload(mac_mode, leftmeta)";
          };
          "mac_mode:M" = {
            c = "C-c";
            v = "C-v";
            x = "C-x";
            z = "C-z";
            w = "C-w";
            t = "C-t";
            f = "C-f";
            C = "C-S-c";
            V = "C-S-v";
          };
        };
      };
    };
  };
}
