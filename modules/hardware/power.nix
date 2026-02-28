{
  flake.modules.nixos.power = {
    services = {
      tlp.enable = false;
      auto-cpufreq.enable = true;
    };
  };
}
