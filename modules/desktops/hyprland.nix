{ config, inputs, lib, pkgs, vars, ... }:

let
  colors = import ../theming/colors.nix;
  hyprland = inputs.hyprland;
in
with lib;
with vars;
{
  options = {
    hyprland = {
      enable = mkOption {
        description = "Enable Hyprland as Wayland window manager";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (config.hyprland.enable) {
    wlwm.enable = true;

    environment =
      let
        exec = "exec dbus-launch start-hyprland";
      in
      {
        loginShellInit = ''
          if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
            ${exec}
          fi
        '';

        # variables = {
        #   # WLR_NO_HARDWARE_CURSORS="1"; # Needed for VM
        #   # WLR_RENDERER_ALLOW_SOFTWARE="1";
        #   XDG_CURRENT_DESKTOP = "Hyprland";
        #   XDG_SESSION_TYPE = "wayland";
        #   XDG_SESSION_DESKTOP = "Hyprland";
        #   XCURSOR = "Catppuccin-Mocha-Dark-Cursors";
        #   XCURSOR_SIZE = 24;
        #   NIXOS_OZONE_WL = 1;
        #   SDL_VIDEODRIVER = "wayland";
        #   OZONE_PLATFORM = "wayland";
        #   WLR_RENDERER_ALLOW_SOFTWARE = 1;
        #   CLUTTER_BACKEND = "wayland";
        #   QT_QPA_PLATFORM = "wayland;xcb";
        #   QT_QPA_PLATFORMTHEME = "qt6ct";
        #   QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        #   QT_AUTO_SCREEN_SCALE_FACTOR = 1;
        #   GDK_BACKEND = "wayland";
        #   WLR_NO_HARDWARE_CURSORS = "1";
        #   MOZ_ENABLE_WAYLAND = "1";
        # };
        systemPackages = with pkgs; [
          grimblast # Screenshot
          hyprcursor # Cursor
          hyprpaper # Wallpaper
          wl-clipboard # Clipboard
          wlr-randr # Monitor Settings
          xwayland # X session
          nwg-look
        ];
      };

    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };

    security.pam.services.hyprlock = {
      # text = "auth include system-auth";
      text = "auth include login";
      enableGnomeKeyring = true;
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
          command = "${config.programs.hyprland.package}/bin/Hyprland"; # tuigreet not needed with exec-once hyprlock
          user = vars.user;
        };
      };
    };

    systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=no
      AllowSuspendThenHibernate=no
      AllowHybridSleep=yes
    ''; # Clamshell Mode

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    home-manager.users.${vars.user} =
      let
        lid = "LID";
        lockScript = pkgs.writeShellScript "lock-script" ''
          action=$1
          ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
          if [ $? == 1 ]; then
            if [ "$action" == "lock" ]; then
              # ${pkgs.hyprlock}/bin/hyprlock
              "noctalia-shell ipc call lockScreen lock"
            elif [ "$action" == "suspend" ]; then
              ${pkgs.systemd}/bin/systemctl suspend
            fi
          fi
        '';
      in
      {
        imports = [
          hyprland.homeManagerModules.default
        ];

        programs.hyprlock = {
          enable = false;
          settings = {
            general = {
              hide_cursor = true;
              no_fade_in = false;
              disable_loading_bar = true;
              grace = 0;
            };
            # background = [{
            #   monitor = "";
            #   path = "$HOME/.config/wall.png";
            #   color = "rgba(25, 20, 20, 1.0)";
            #   blur_passes = 1;
            #   blur_size = 0;
            #   brightness = 0.2;
            # }];
            # input-field = [
            #   {
            #     monitor = "";
            #     size = "250, 60";
            #     outline_thickness = 2;
            #     dots_size = 0.2;
            #     dots_spacing = 0.2;
            #     dots_center = true;
            #     outer_color = "rgba(0, 0, 0, 0)";
            #     inner_color = "rgba(0, 0, 0, 0.5)";
            #     font_color = "rgb(200, 200, 200)";
            #     fade_on_empty = false;
            #     placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
            #     hide_input = false;
            #     position = "0, -120";
            #     halign = "center";
            #     valign = "center";
            #   }
            # ];
            label = [
              {
                monitor = "";
                text = "$TIME";
                font_size = 120;
                position = "0, 200";
                # valign = "center";
                halign = "center";
              }
            ];
          };
        };

        services.hypridle = {
          enable = true;
          settings = {
            general = {
              before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
              after_sleep_cmd = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on";
              ignore_dbus_inhibit = true;
              # lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
              lock_cmd = "noctalia-shell ipc call lockScreen lock";
            };
            listener = [
              {
                timeout = 300;
                # on-timeout = "${lockScript.outPath} lock";
                on-timeout = "noctalia-shell ipc call lockScreen lock";
              }
              {
                timeout = 1800;
                on-timeout = "${lockScript.outPath} suspend";
              }
            ];
          };
        };

        services.hyprpaper = {
          enable = false;
          settings = {
            ipc = true;
            splash = false;
            preload = "$HOME/.config/wall.png";
            wallpaper = ",$HOME/.config/wall.png";
          };
        };

        wayland.windowManager.hyprland = with colors.scheme.default.hex; {
          enable = true;
          package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          xwayland.enable = true;
          settings = {
            general = {
              border_size = 2;
              gaps_in = 3;
              gaps_out = 6;
              # "col.active_border" = "0x99${active}";
              # "col.inactive_border" = "0x66${inactive}";
              resize_on_border = true;
              hover_icon_on_border = false;
              layout = "dwindle";
            };
            decoration = {
              rounding = 6;
              active_opacity = 1;
              inactive_opacity = 1;
              fullscreen_opacity = 1;
            };
            monitor = [
              ",preferred,auto,1,mirror,${toString mainMonitor}"
            ] ++ (if hostName == "beelink" then [
              "${toString mainMonitor},1920x1080@60,1920x0,1"
              "${toString secondMonitor},1920x1080@60,0x0,1"
            ] else if hostName == "work" then [
              "${toString mainMonitor},preferred,0x0,1"
              "${toString secondMonitorDesc},1920x1200@60,1920x0,1"
              "${toString thirdMonitorDesc},1920x1200@60,3840x0,1"
            ] else [
              "${toString mainMonitor},1920x1080@60,0x0,1"
            ]);
            workspace =
              if hostName == "beelink" then [
                "1, monitor:${toString mainMonitor}"
                "2, monitor:${toString mainMonitor}"
                "3, monitor:${toString mainMonitor}"
                "4, monitor:${toString mainMonitor}"
                "5, monitor:${toString secondMonitor}"
                "6, monitor:${toString secondMonitor}"
                "7, monitor:${toString secondMonitor}"
                "8, monitor:${toString secondMonitor}"
              ] else if hostName == "work" then [
                "1, monitor:${toString mainMonitor}"
                "2, monitor:${toString mainMonitor}"
                "3, monitor:${toString mainMonitor}"
                "4, monitor:${toString secondMonitor}"
                "5, monitor:${toString secondMonitor}"
                "6, monitor:${toString secondMonitor}"
              ] else [ ];
            animations = {
              enabled = false;
              bezier = [
                "overshot, 0.05, 0.9, 0.1, 1.05"
                "smoothOut, 0.5, 0, 0.99, 0.99"
                "smoothIn, 0.5, -0.5, 0.68, 1.5"
                "rotate,0,0,1,1"
              ];
              animation = [
                "windows, 1, 4, overshot, slide"
                "windowsIn, 1, 2, smoothOut"
                "windowsOut, 1, 1, smoothOut"
                "windowsMove, 1, 3, smoothIn, slide"
                "border, 1, 5, default"
                "fade, 1, 4, smoothIn"
                "fadeDim, 1, 4, smoothIn"
                "workspaces, 1, 4, default"
                "borderangle, 1, 20, rotate, loop"
              ];
            };
            input = {
              kb_layout = "us";
              # kb_layout=us,us
              # kb_variant=,dvorak
              # kb_options=caps:ctrl_modifier
              kb_options = "caps:escape";
              follow_mouse = 2;
              repeat_delay = 250;
              numlock_by_default = 1;
              accel_profile = "adaptive";
              sensitivity = 0.5;
              natural_scroll = false;
              touchpad =
                if hostName == "work" then {
                  natural_scroll = true;
                  scroll_factor = 0.2;
                  middle_button_emulation = true;
                  tap-to-click = true;
                } else { };
            };
            device = {
              name = "matthias’s-magic-mouse";
              sensitivity = 0.5;
              natural_scroll = true;
            };
            cursor = {
              no_hardware_cursors = true;
            };
            gestures =
              if hostName == "work" then {
                workspace_swipe = true;
                workspace_swipe_fingers = 3;
                workspace_swipe_distance = 100;
                workspace_swipe_create_new = true;
              } else { };
            dwindle = {
              pseudotile = false;
              force_split = 2;
              preserve_split = true;
            };
            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              mouse_move_enables_dpms = true;
              mouse_move_focuses_monitor = true;
              key_press_enables_dpms = true;
              # background_color = "0x111111";
            };
            debug = {
              damage_tracking = 2;
            };
            ecosystem = {
              no_update_news = true;
            };
            bindm = [
              "SUPER,mouse:272,movewindow"
              "SUPER,mouse:273,resizewindow"
            ];
            bind = [
              "SUPER,Return,exec,${pkgs.${vars.terminal}}/bin/${vars.terminal}"
              "SUPER,Q,killactive,"
              "SUPER,Escape,exit,"
              #"SUPER,S,exec,${pkgs.systemd}/bin/systemctl suspend"
              #"SUPER,L,exec,${pkgs.hyprlock}/bin/hyprlock"
              "SUPER,S,exec,noctalia-shell ipc call lockScreen lock && ${pkgs.systemd}/bin/systemctl suspend"
              "SUPER,L,exec,noctalia-shell ipc call lockScreen lock"
              "SUPER,E,exec,${pkgs.thunar}/bin/thunar"
              "SUPER,F,togglefloating,"
              # "SUPER,Space,exec, pkill wofi || ${pkgs.wofi}/bin/wofi --show drun"
              "SUPER,Space,exec, noctalia-shell ipc call launcher toggle"
              "SUPER,P,pseudo,"
              ",F11,fullscreen,"
              "SUPER,R,forcerendererreload"
              "SUPERSHIFT,R,exec,${config.programs.hyprland.package}/bin/hyprctl reload"
              "SUPER,T,exec,${pkgs.${vars.terminal}}/bin/${vars.terminal} -e nvim"
              "SUPER,K,exec,${config.programs.hyprland.package}/bin/hyprctl switchxkblayout keychron-k8-keychron-k8 next"
              "SUPER,left,movefocus,l"
              "SUPER,right,movefocus,r"
              "SUPER,up,movefocus,u"
              "SUPER,down,movefocus,d"
              "SUPERSHIFT,left,movewindow,l"
              "SUPERSHIFT,right,movewindow,r"
              "SUPERSHIFT,up,movewindow,u"
              "SUPERSHIFT,down,movewindow,d"
              "SUPERCTRL,1,workspace,1"
              "SUPERCTRL,2,workspace,2"
              "SUPERCTRL,3,workspace,3"
              "SUPERCTRL,4,workspace,4"
              "SUPERCTRL,5,workspace,5"
              "SUPERCTRL,6,workspace,6"
              "SUPERCTRL,7,workspace,7"
              "SUPERCTRL,8,workspace,8"
              "SUPERCTRL,9,workspace,9"
              "SUPERCTRL,0,workspace,10"
              "SUPERCTRL,right,workspace,+1"
              "SUPERCTRL,left,workspace,-1"
              "SUPERCTRLSHIFT,1,movetoworkspace,1"
              "SUPERCTRLSHIFT,2,movetoworkspace,2"
              "SUPERCTRLSHIFT,3,movetoworkspace,3"
              "SUPERCTRLSHIFT,4,movetoworkspace,4"
              "SUPERCTRLSHIFT,5,movetoworkspace,5"
              "SUPERCTRLSHIFT,6,movetoworkspace,6"
              "SUPERCTRLSHIFT,7,movetoworkspace,7"
              "SUPERCTRLSHIFT,8,movetoworkspace,8"
              "SUPERCTRLSHIFT,9,movetoworkspace,9"
              "SUPERCTRLSHIFT,0,movetoworkspace,10"
              "SUPERCTRLSHIFT,right,movetoworkspace,+1"
              "SUPERCTRLSHIFT,left,movetoworkspace,-1"

              "SUPER,Z,layoutmsg,togglesplit"
              ",print,exec,${pkgs.grimblast}/bin/grimblast --notify --freeze --wait 1 copysave area ~/Pictures/$(date +%Y-%m-%dT%H%M%S).png"
              ",XF86AudioLowerVolume,exec,${pkgs.pamixer}/bin/pamixer -d 10"
              ",XF86AudioRaiseVolume,exec,${pkgs.pamixer}/bin/pamixer -i 10"
              ",XF86AudioMute,exec,${pkgs.pamixer}/bin/pamixer -t"
              "SUPER_L,c,exec,${pkgs.pamixer}/bin/pamixer --default-source -t"
              "CTRL,F10,exec,${pkgs.pamixer}/bin/pamixer -t"
              ",XF86AudioMicMute,exec,${pkgs.pamixer}/bin/pamixer --default-source -t"
              ",XF86MonBrightnessDown,exec,${pkgs.light}/bin/light -U 10"
              ",XF86MonBrightnessUP,exec,${pkgs.light}/bin/light -A 10"
            ];
            binde = [
              "SUPERALT,right,resizeactive,60 0"
              "SUPERALT,left,resizeactive,-60 0"
              "SUPERALT,up,resizeactive,0 -60"
              "SUPERALT,down,resizeactive,0 60"
            ];
            bindl =
              if hostName == "work" then [
                ",switch:Lid Switch,exec,$HOME/.config/hypr/script/clamshell.sh"
              ] else [ ];
            windowrule = [
              "match:title ^(Volume Control)$, float on"
              "match:class ^(firefox)$, match:title ^(Picture-in-Picture)$, keep_aspect_ratio on, border_size 0, float on, size 24% 24%, move 75% 75%, pin on"
              "match:class ^(kitty)$, opacity 0.9"
            ];
            exec-once = [
              "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
              # "${pkgs.hyprlock}/bin/hyprlock"
              "ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr"
              # "${pkgs.waybar}/bin/waybar -c $HOME/.config/waybar/config"
              # "${pkgs.eww}/bin/eww daemon"
              "noctalia-shell"
              # "${pkgs.swayidle}/bin/swayidle -w timeout 300 noctalia-shell ipc call lockScreen lock before-sleep noctalia-shell ipc call lockScreen lock"
              # "$HOME/.config/eww/scripts/eww" # When running eww as a bar
              # "${pkgs.blueman}/bin/blueman-applet"
              # "${pkgs.swaynotificationcenter}/bin/swaync"
              # "${pkgs.hyprpaper}/bin/hyprpaper"
            ] ++ (if hostName == "work" then [
              "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
              "${pkgs.rclone}/bin/rclone mount --daemon gdrive: /GDrive --vfs-cache-mode=writes"
              # "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse /GDrive"
            ] else [ ]);
            # env = [
            #   "XCURSOR,Catppuccin-Mocha-Dark-Cursors"
            #   "XCURSOR_SIZE,24"
            # ];
          };
        };

        home.file = {
          ".config/hypr/script/clamshell.sh" = {
            text = ''
              #!/bin/sh

              if grep open /proc/acpi/button/lid/${lid}/state; then
                ${config.programs.hyprland.package}/bin/hyprctl keyword monitor "${toString mainMonitor}, 1920x1080, 0x0, 1"
              else
                if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
                  ${config.programs.hyprland.package}/bin/hyprctl keyword monitor "${toString mainMonitor}, disable"
                else
                noctalia-shell ipc call lockScreen lock
                  ${pkgs.systemd}/bin/systemctl suspend
                fi
              fi
            '';
            executable = true;
          };
        };
      };
  };
}
