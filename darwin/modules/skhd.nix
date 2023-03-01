{ config, lib, pkgs, ... }:

{
  services = {
    skhd = {                              # Hotkey daemon
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
          # reload yabai
          shift + alt - r : brew services restart yabai && brew services restart skhd && brew services restart sketchybar

          # Navigation
          alt - h : yabai -m window --focus west
          alt - j : yabai -m window --focus south
          alt - k : yabai -m window --focus north
          alt - l : yabai -m window --focus east

          # Moving windows
          shift + alt - h : yabai -m window --warp west
          shift + alt - j : yabai -m window --warp south
          shift + alt - k : yabai -m window --warp north
          shift + alt - l : yabai -m window --warp east

          # Move focus container to workspace
          shift + alt - 1 : yabai -m window --space 1
          shift + alt - 2 : yabai -m window --space 2
          shift + alt - 3 : yabai -m window --space 3
          shift + alt - 4 : yabai -m window --space 4
          shift + alt - 5 : yabai -m window --space 5
          shift + alt - 6 : yabai -m window --space 6
          shift + alt - 7 : yabai -m window --space 7
          shift + alt - 8 : yabai -m window --space 8
          shift + alt - 9 : yabai -m window --space 9

          # Move focus to space
          # Yabai has the ability to do this, but only with scripting-addition

          # rotate tree
          alt - r : yabai -m space --rotate 90

          # Resize windows
          ctrl + alt - h : \
              yabai -m window --resize left:-100:0 ; \
              yabai -m window --resize right:-100:0

          ctrl + alt - j : \
              yabai -m window --resize bottom:0:100 ; \
              yabai -m window --resize top:0:100

          ctrl + alt - k : \
              yabai -m window --resize top:0:-100 ; \
              yabai -m window --resize bottom:0:-100

          ctrl + alt - l : \
              yabai -m window --resize right:100:0 ; \
              yabai -m window --resize left:100:0

          # toggle window split type
          alt - s : yabai -m window --toggle split

          # toggle window fullscreen zoom
          alt - f : yabai -m window --toggle zoom-fullscreen

          # toggle padding and gap
          alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

          # float / unfloat window and center on ecreen
          alt - c : yabai -m window --toggle float;\
                    yabai -m window --grid 4:4:1:1:2:2

          # balance size of windows
          shift + alt - 0 : yabai -m space --balance

          # Set insertion point for focused container
          shift + ctrl + alt - h : yabai -m window --insert west
          shift + ctrl + alt - j : yabai -m window --insert south
          shift + ctrl + alt - k : yabai -m window --insert north
          shift + ctrl + alt - l : yabai -m window --insert east

          shift + ctrl + alt - n : osascript -e 'tell application "Spotify" to Next Track'
          shift + ctrl + alt - p : osascript -e 'tell application "Spotify" to Previous Track'

          shift + ctrl + alt - up : osascript -e 'tell application "Spotify" to set sound volume to 100'
          shift + ctrl + alt - down : osascript -e 'tell application "Spotify" to set sound volume to 20'

          # volume contorl
          shift + alt - down : osascript -e "set volume output volume ((output volume of (get volume settings)) - 3)"
          shift + alt - up : osascript -e "set volume output volume ((output volume of (get volume settings)) + 3)"

          # Play Pause
          shift + alt - space : osascript -e 'tell application "Spotify" to playpause'

          # flow app
          shift + alt - p : osascript ~/.config/scripts/flow.applescript

          # ddcctl - dell monitor source switching
          # move to Linux 
          shift + ctrl - 1 : ddcctl -d 1 -i 17
          # move to windows vm
          shift + ctrl - 2 : ddcctl -d 1 -i 15
          # move back to macOS
          shift + ctrl - 3 : ddcctl -d 1 -i 27


          lalt - space : yabai -m window --toggle float; sketchybar --trigger window_focus
          shift + lalt - f : yabai -m window --toggle zoom-fullscreen; sketchybar --trigger window_focus
          lalt - f : yabai -m window --toggle zoom-parent; sketchybar --trigger window_focus

      '';                                 # Hotkey config
    };
  };

  system = {
    keyboard = {
      enableKeyMapping = true;            # Needed for skhd
    };
  };
}
