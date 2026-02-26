{
  flake.modules.editors.nixvim = {
    autoCmd = [
      {
        event = "BufWritePre";
        command = "%s/\\s\\+$//e";
        desc = "Remove whitespaces on write";
      }
      {
        event = "FileType";
        pattern = [ "markdown" ];
        callback = {
          __raw = ''
            function()
              vim.cmd("setlocal spell spelllang=en,nl")
              vim.keymap.set("n", "<TAB>", "z=", { noremap = true, silent = true, buffer = true })
            end
          '';
        };
        desc = "Enable spellchecking";
      }
      {
        desc = "Open file at the last position it was edited earlier";
        event = "BufReadPost";
        pattern = "*";
        command = "silent! normal! g`\"zv";
      }
    ];
  };
}
