{
  flake.modules.editors.nixvim =
    { pkgs, ... }:
    {
      plugins.snacks.enable = true;
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin rec {
          pname = "claudecode.nvim";
          version = "main";
          src = pkgs.fetchFromGitHub {
            owner = "coder";
            repo = "claudecode.nvim";
            rev = version;
            sha256 = "sha256-r8hAUpSsr8zNm+av8Mu5oILaTfEsXEnJmkzRmvi9pF8=";
          };
        })
      ];

      keymaps = [
        {
          mode = "n";
          key = "<leader>ac";
          action = "<cmd>ClaudeCode<cr>";
          options.desc = "Toggle Claude";
        }
        {
          mode = "n";
          key = "<leader>af";
          action = "<cmd>ClaudeCodeFocus<cr>";
          options.desc = "Focus Claude";
        }
        {
          mode = "n";
          key = "<leader>ar";
          action = "<cmd>ClaudeCode --resume<cr>";
          options.desc = "Resume Claude";
        }
        {
          mode = "n";
          key = "<leader>aC";
          action = "<cmd>ClaudeCode --continue<cr>";
          options.desc = "Continue Claude";
        }
        {
          mode = "n";
          key = "<leader>am";
          action = "<cmd>ClaudeCodeSelectModel<cr>";
          options.desc = "Select Claude model";
        }
        {
          mode = "n";
          key = "<leader>ab";
          action = "<cmd>ClaudeCodeAdd %<cr>";
          options.desc = "Add current buffer";
        }
        {
          mode = "v";
          key = "<leader>as";
          action = "<cmd>ClaudeCodeSend<cr>";
          options.desc = "Send to Claude";
        }
        {
          mode = "n";
          key = "<leader>aa";
          action = "<cmd>ClaudeCodeDiffAccept<cr>";
          options.desc = "Accept diff";
        }
        {
          mode = "n";
          key = "<leader>ad";
          action = "<cmd>ClaudeCodeDiffDeny<cr>";
          options.desc = "Deny diff";
        }
      ];

      extraConfigLua = ''
        require("claudecode").setup()
      '';
    };
}
