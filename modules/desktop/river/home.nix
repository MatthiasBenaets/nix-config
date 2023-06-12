#
#  River Home-manager configuration
#

{ config, lib, pkgs, host, ... }:

let
  monitor = with host;
    if hostName == "desktop" then
      "riverctl spawn ${pkgs.wlr-randr}/bin/wlr-randr --output ${secondMonitor} --mode 1920x1080@60 --pos 0,0 --output ${mainMonitor} --mode 1920x1080@60 --pos 1920,0"
    else if hostName == "laptop" || hostName == "vm" then
      "riverctl spawn ${pkgs.wlr-randr}/bin/wlr-randr --output ${mainMonitor} --mode 1920x1080@60 --pos 0,0"
    else false;
in
{
  home.file = {
    ".config/river/init" = {
      executable = true;
      text = ''
        #!/bin/sh

        riverctl spawn systemctl --user import-environment                          # Fixes super slow loading of gtk apps

        ${monitor}                                                                  # Monitor settings
        riverctl spawn ${pkgs.waybar}/bin/waybar

        riverctl map normal Super+Shift E exit                                      # Exit River
        riverctl map normal Super Q close                                           # Close window

        riverctl map normal Super Return spawn alacritty                            # Terminal Emulator

        riverctl map normal Super J focus-view next                                 # Focus next or previous layout stack
        riverctl map normal Super K focus-view previous

        riverctl map normal Super+Shift J swap next                                 # Swap focused view with the next or previous view in layout stack
        riverctl map normal Super+Shift K swap previous

        riverctl map normal Super Period focus-output next                          # Focus next or previous output
        riverctl map normal Super Comma focus-output previous

        riverctl map normal Super+Shift Period send-to-output next                  # Send focus view to next or previous output
        riverctl map normal Super+Shift Comma send-to-output previous

        riverctl map normal Super+Shift Return zoom                                 # Bump focused view to top of layout stack

        riverctl map normal Super H send-layout-cmd rivertile "main-ratio -0.05"    # Decrease or increate main ratio of rivertile
        riverctl map normal Super L send-layout-cmd rivertile "main-ratio +0.05"
        riverctl map-pointer normal Super BTN_RIGHT resize-view

        riverctl map normal Super+Shift H send-layout-cmd rivertile "main-count +1" # Increment or decrement main count of rivertile
        riverctl map normal Super+Shift L send-layout-cmd rivertile "main-count -1"

        riverctl map normal Super+Alt H move left 100                               # Move views
        riverctl map normal Super+Alt J move down 100
        riverctl map normal Super+Alt K move up 100
        riverctl map normal Super+Alt L move right 100
        riverctl map-pointer normal Super BTN_LEFT move-view

        riverctl map normal Super+Alt+Control H snap left                           # Snap views to screen edge
        riverctl map normal Super+Alt+Control J snap down
        riverctl map normal Super+Alt+Control K snap up
        riverctl map normal Super+Alt+Control L snap right                          # Swap focused view with next or previous

        riverctl map normal Super+Alt+Shift H resize horizontal -100                # Resize view
        riverctl map normal Super+Alt+Shift J resize vertical 100
        riverctl map normal Super+Alt+Shift K resize vertical -100
        riverctl map normal Super+Alt+Shift L resize horizontal 100

        for i in $(seq 1 9)
        do
            tags=$((1 << ($i - 1)))
            riverctl map normal Super $i set-focused-tags $tags                     # Focus tag
            riverctl map normal Super+Shift $i set-view-tags $tags                  # Tag focused view with tag x
            riverctl map normal Super+Control $i toggle-focused-tags $tags          # Toggle focus of tag x
            riverctl map normal Super+Shift+Control $i toggle-view-tags $tags       # Toggle tag x of focused view
        done

        all_tags=$(((1 << 32) - 1))
        riverctl map normal Super 0 set-focused-tags $all_tags                      # Focus all tags
        riverctl map normal Super+Shift 0 set-view-tags $all_tags                   # Tag focused view with all tags

        riverctl map normal Super Space toggle-float                                # Toggle float

        riverctl map normal Super F toggle-fullscreen                               # Toggle Fullscreen

        riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"   # Change layout orientation
        riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
        riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
        riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"

        riverctl declare-mode passthrough                                           # Declare passthrough mode, for testing nested wayland compositor. Only mapped key is return to normal mode
        riverctl map normal Super F11 enter-mode passthrough                        # Enter passthrough mode
        riverctl map passthrough Super F11 enter-mode normal                        # Enter normal mode

        for mode in normal locked                                                   # Mapped media keys
        do
            riverctl map $mode None XF86Eject spawn 'eject -T'                      # Eject optical drive

            riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'      # Pulse audio volume
            riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
            riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'

            riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'     # MPRIS music player
            riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
            riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
            riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

            riverctl map $mode None XF86MonBrightnessUp   spawn 'light -A 5'        # Backlight management
            riverctl map $mode None XF86MonBrightnessDown spawn 'light -U 5'
        done

        riverctl background-color 0x002b36                                          # Set background and border color
        riverctl border-color-focused 0x93a1a1
        riverctl border-color-unfocused 0x586e75

        riverctl set-repeat 50 300                                                  # Keyboard repeat rate

        riverctl float-filter-add app-id float                                      # Make views start out floating
        riverctl float-filter-add title "popup title with spaces"

        riverctl csd-filter-add app-id "gedit"                                      # Set app-ids and titles of vies which should use clien side decorations

        riverctl default-layout rivertile                                           # Set default layout to rivertile
        rivertile -view-padding 6 -outer-padding 6
      '';
    };
  };
}
