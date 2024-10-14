#
#  Network Shares
#

{ vars, ... }:

{
  services = {
    samba = {
      enable = true;
      settings = {
        # Set Password: $ smbpasswd -a <user>
        share = {
          "path" = "/home/${vars.user}";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
  };
}
