{ config, pkgs, user, system ... }: {

  specialArgs = { user = "tom.meadows"; };

  networking = {
    computerName = "Toms MacBook";             # Host name
    hostName = "WKSMAC151152";
  };

}
