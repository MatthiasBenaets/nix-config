{
  flake.modules.homeManager.kitty = {
    programs = {
      kitty = {
        enable = true;
        settings = {
          confirm_os_window_close = 0;
          enable_audio_bell = "no";
          resize_debounce_time = "0";
        };
      };
    };
  };
}
