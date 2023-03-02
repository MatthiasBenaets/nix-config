#
# Terminal Emulator
#
# Hardcoded as terminal for rofi and doom emacs
#

{ pkgs, ... }:

{
  programs = {
    alacritty = {
      # Install via Homebrew Cask for icon and better indexing behavior.
      package = pkgs.runCommand "alacritty-0.0.0" {} "mkdir $out";
      enable = true;
      settings = {
        window.decorations = "none";
        startup_mode = "Maximised";
        font = rec {                          # Font - Laptop has size manually changed at home.nix
          normal.family = "JetBrainsMono Nerd Font";
          bold = { style = "Bold"; };
          size = 16;
        };
        offset = {                            # Positioning
          x = -1;
          y = 0;
        };
        # Colors (Gruvbox Dark)
        colors = {
          # hard contrast: background = "0x1d2021"
          # soft contrast: background = "0x32302f"
          primary.background = "0x282828";
          primary.foreground = "0xebdbb2";
          normal = {
            black = "0x282828";
            red = "0xcc241d";
            green = "0x98971a";
            yellow = "0xd78821";
            blue = "0x458588";
            magenta = "0xb16286";
            cyan = "0x689d6a";
            white = "0xa89984";
          };
          bright = {
            black = "0x928374";
            red = "0xfb4934";
            green = "0xb8bb26";
            yellow = "0xfabd2f";
            blue = "0x83a598";
            magenta = "0xd3869b";
            cyan = "0x8ec07c";
            white = "0xebdbb2";
          };
        };
        keybindings = [
          { key = "Right";     mods = "Alt";     chars = "\\x1bf"; }
          { key = "Left";     mods = "Alt";     chars = "\\x1bb"; }
          { key = "N";     mods = "Command";     action = "CreateNewWindow"; }
        ];
      };
    };
  };
}
