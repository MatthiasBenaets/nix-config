#
#  Sway Configuration
#  Enable with "sway.enable = true;"
#

{ config, lib, pkgs, vars, host, ... }:

with lib;
with host;
{
  options = {
    sway = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (config.sway.enable) {
    wlwm.enable = true;                     # Wayland Window Manager

    environment = {
      loginShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec sway
        fi
      '';                                   # Start from TTY1
      variables = {
        #LIBCL_ALWAYS_SOFTWARE = "1";       # Needed for VM
        #WLR_NO_HARDWARE_CURSORS = "1";
      };
    };

    programs = {
      sway = {                              # Window Manager
        enable = true;
        extraPackages = with pkgs; [
          autotiling      # Tiling Script
          wev             # Event Viewer
          wl-clipboard    # Clipboard
          wlr-randr       # Monitor settings
          xwayland        # X for Wayland
        ];
      };
    };

    home-manager.users.${vars.user} = {
      wayland.windowManager.sway = {
        enable = true;
        systemd.enable = true;
        config = rec {
          modifier = "Mod4";
          terminal = "${pkgs.${vars.terminal}}/bin/${vars.terminal}";
          menu = "${pkgs.wofi}/bin/wofi --show drun";

          startup = [
            {command = "${pkgs.autotiling}/bin/autotiling"; always = true;}
            {command = "exec ${pkgs.blueman}/bin/blueman-applet"; always = true;}
          ];

          bars = [];                        # Using Waybar

          fonts = {
            names = [ "Source Code Pro" ];
            size = 10.0;
          };

          # gaps = {
          #   inner = 5;
          #   outer = 5;
          # };

          input = {                         # Input modules: $ man sway-input
            "type:touchpad" = {
              tap = "disabled";
              dwt = "enabled";
              scroll_method = "two_finger";
              middle_emulation = "enabled";
              natural_scroll = "enabled";
            };
            "type:keyboard" = {
              xkb_layout = "us";
              xkb_numlock = "enabled";
            };
          };

          output = if hostName == "h310m" then {
            "*".bg = "~/.config/wall.png fill";#
            "*".scale = "1";#
            "${secondMonitor}" = {
              mode = "1920x1080";
              pos = "0 0";
            };
            "${mainMonitor}" = {
              mode = "1920x1080";
              pos = "1920 0";
            };
          } else if hostName == "probook" then {
            "*".bg = "~/.config/wall fill";
            "*".scale = "1";
            "${mainMonitor}" = {
              mode = "1920x108";
              pos = "0 0";
            };
          } else {};

          workspaceOutputAssign = if hostName == "beelink" || hostName == "h310m" then [
            {output = mainMonitor; workspace = "1";}
            {output = mainMonitor; workspace = "2";}
            {output = mainMonitor; workspace = "3";}
            {output = mainMonitor; workspace = "4";}
            {output = secondMonitor; workspace = "5";}
            {output = secondMonitor; workspace = "6";}
            {output = secondMonitor; workspace = "7";}
            {output = secondMonitor; workspace = "8";}
          ] else if hostName == "probook" then [
            {output = mainMonitor; workspace = "1";}
            {output = mainMonitor; workspace = "2";}
            {output = mainMonitor; workspace = "3";}
          ] else [];
          defaultWorkspace = "workspace number 1";

          colors.focused = {
            background = "#999999";
            border = "#999999";
            childBorder = "#999999";
            indicator = "#212121";
            text = "#999999";
          };

          keybindings = {                                   # Hotkeys
            "${modifier}+Escape" = "exec swaymsg exit";     # Exit
            "${modifier}+Return" = "exec ${terminal}";      # Terminal
            "${modifier}+space" = "exec ${menu}";           # Menu
            "${modifier}+e" = "exec ${pkgs.pcmanfm}/bin/pcmanfm"; # File Manager
            "${modifier}+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy"; # Lock Screen

            "${modifier}+r" = "reload";                     # Reload Environment
            "${modifier}+q" = "kill";                       # Kill
            "${modifier}+f" = "fullscreen toggle";          # Fullscreen
            "${modifier}+h" = "floating toggle";            # Floating

            "${modifier}+Left" = "focus left";              # Focus
            "${modifier}+Right" = "focus right";
            "${modifier}+Up" = "focus up";
            "${modifier}+Down" = "focus down";

            "${modifier}+Shift+Left" = "move left";         # Move
            "${modifier}+Shift+Right" = "move right";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Down" = "move down";

            "Alt+Left" = "workspace prev_on_output";        # Navigate workspaces
            "Alt+Right" = "workspace next_on_output";

            "Alt+1" = "workspace number 1";                 # Open Workspace
            "Alt+2" = "workspace number 2";
            "Alt+3" = "workspace number 3";

            "Alt+Shift+Left" = "move container to workspace prev, workspace prev";    # Move to Workspace
            "Alt+Shift+Right" = "move container to workspace next, workspace next";

            "Alt+Shift+1" = "move container to workspace number 1";     # Move to Workspace
            "Alt+Shift+2" = "move container to workspace number 2";
            "Alt+Shift+3" = "move container to workspace number 3";
            "Alt+Shift+4" = "move container to workspace number 4";
            "Alt+Shift+5" = "move container to workspace number 5";

            "Control+Up" = "resize shrink height 20px";     # Resize
            "Control+Down" = "resize grow height 20px";
            "Control+Left" = "resize shrink width 20px";
            "Control+Right" = "resize grow width 20px";

            "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui"; # Screenshots

            "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 10";   # Volume
            "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 10";
            "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";             # Media
            "XF86AudioMicMute" = "exec ${pkgs.pamixer}/bin/pamixer --default-source -t";

            "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U  5";      # Brightness
            "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
          };
        };
        extraConfig = ''
          set $opacity 0.8
          for_window [class=".*"] opacity 0.95
          for_window [app_id=".*"] opacity 0.95
          for_window [app_id="thunar"] opacity 0.95, floating enable
          for_window [app_id="Alacritty"] opacity $opacity
          for_window [title="drun"] opacity $opacity
          for_window [class="Emacs"] opacity $opacity
          for_window [app_id="pavucontrol"] floating enable, sticky
          for_window [app_id=".blueman-manager-wrapped"] floating enable
          for_window [title="Picture in picture"] floating enable, move position 1205 634, resize set 700 400, sticky enable
        '';                                    # $ swaymsg -t get_tree or get_outputs
        extraSessionCommands = ''
          #export WLR_NO_HARDWARE_CURSORS="1";  # Needed for cursor in vm
          export XDG_SESSION_TYPE=wayland
          export XDG_SESSION_DESKTOP=sway
          export XDG_CURRENT_DESKTOP=sway
        '';
      };
    };
  };
}
