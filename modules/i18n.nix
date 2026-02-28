{
  flake.modules.nixos.base = {
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_MONETARY = "nl_BE.UTF-8";
      };
    };
  };
}
