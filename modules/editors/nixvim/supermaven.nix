{
  flake.modules.editors.nixvim = { lib, ... }: {
    plugins.supermaven = {
      enable = true;
      settings = {
        keymaps = {
          accept_suggestion = "<Tab>";
        };
        log_level = "info";
        disable_inline_completion = false;
        disable_keymaps = false;
        condition = lib.nixvim.mkRaw ''
          function()
            return false
          end
        '';
      };
    };
  };
}
