{
  flake.modules.editors.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      {
        key = "<C-s>";
        action = "<CMD>w<CR>";
        options.desc = "Save";
      }
      {
        key = "<leader>q";
        action = "<CMD>q<CR>";
        options.desc = "Quit";
      }
      {
        mode = "i";
        key = "jk";
        action = "<ESC>";
        options.desc = "Exit Insert Mode";
      }
      {
        key = "<leader>e";
        action = "<CMD>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
      }
      {
        key = "<leader>sh";
        action = "<C-w>s";
        options.desc = "Split Horizontal";
      }
      {
        key = "<leader>sv";
        action = "<C-w>v";
        options.desc = "Split Vertical";
      }
      {
        key = "<leader>sx";
        action = "<CMD>close<CR>";
        options.desc = "Split Close";
      }
      {
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Select Window Left";
      }
      {
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Select Window Right";
      }
      {
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Select Window Below";
      }
      {
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Select Window Above";
      }
      {
        key = "<leader>t";
        action = "<C-w>w";
        options.desc = "Cycle Between Windows";
      }
      {
        key = "<leader>bb";
        action = "<CMD>BufferLinePick<CR>";
        options.desc = "Select Buffer";
      }
      {
        key = "<leader>bk";
        action = "<CMD>BufferLinePickClose<CR>";
        options.desc = "Close Buffer";
      }
      {
        key = "<leader>bn";
        action = "<CMD>BufferLineCycleNext<CR>";
        options.desc = "Next Buffer";
      }
      {
        key = "<leader>bp";
        action = "<CMD>BufferLineCyclePrev<CR>";
        options.desc = "Previous Buffer";
      }
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options.desc = "Tab Text Right";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options.desc = "Tab Text Left";
      }
      {
        mode = "n";
        key = "gd";
        action = "<CMD>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Show lsp definition in floating window";
      }
      {
        mode = "n";
        key = "gD";
        action = "<CMD>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Load lsp definition in new buffer";
      }
      {
        mode = "n";
        key = "ge";
        action = "<CMD>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Show lsp diagnostic in floating window";
      }
      {
        mode = "n";
        key = "<leader>r";
        action = ":! ";
        options.desc = "Run command";
      }
      {
        mode = "n";
        key = "<TAB>";
        action = "z=";
        options.desc = "Get spell suggestion";
      }
      {
        mode = "n";
        key = "<C-/>";
        action = "<Plug>(comment_toggle_linewise_current)";
        options.desc = "(Un)comment in Normal Mode";
      }
      {
        mode = "v";
        key = "<C-/>";
        action = "<Plug>(comment_toggle_linewise_visual)";
        options.desc = "(Un)comment in Visual Mode";
      }
      {
        mode = "n";
        key = "<C-S-/>";
        action = "<Plug>(comment_toggle_blockwise_current)";
        options.desc = "(Un)comment in Normal Mode";
      }
      {
        mode = "v";
        key = "<C-S-/>";
        action = "<Plug>(comment_toggle_blockwise_visual)";
        options.desc = "(Un)comment in Visual Mode";
      }
      {
        mode = "v";
        key = "p";
        action = "_dP";
        options.desc = "Don't yank pasted over text";
      }
      {
        mode = "n";
        key = "<ESC>";
        action = "<CMD>nohlsearch<CR>";
        options.desc = "Clear highlighting after search";
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
        options.desc = "Center cursor after search";
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options.desc = "Center cursor after search";
      }
      {
        mode = "n";
        key = "<TAB>";
        action = "z=";
        options.desc = "Get spell suggestion";
      }
      {
        mode = "t";
        key = "<ESC>";
        action = "<C-\\><C-n>";
        options.desc = "Escape terminal mode";
      }
      {
        mode = "n";
        key = "<leader>tf";
        action = "<CMD>lua vim.g.disable_autoformat = not vim.g.disable_autoformat; vim.notify('Autoformat ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled'))<CR>";
        options.desc = "Toggle autoformat";
      }
    ];
  };
}
