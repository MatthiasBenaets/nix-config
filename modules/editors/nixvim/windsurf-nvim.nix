{
  flake.modules.editors.nixvim = {
    plugins.windsurf-nvim = {
      enable = true;
      settings = {
        virtual_text.enabled = true;
        keymaps = {
          accept = "<Tab>";
        };
      };
    };
  };
}
