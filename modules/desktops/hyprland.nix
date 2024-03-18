#
#  Hyprland Configuration
#  Enable with "hyprland.enable = true;"
#

{ config, lib, system, pkgs, hyprland, hyprlock, hypridle, vars, host, ... }:

let
  colors = import ../theming/colors.nix;
in
with lib;
with host;
{
  options = {
    hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (config.hyprland.enable) {
    wlwm.enable = true;                       # Wayland Window Manager

    environment =
    let
      exec = "exec dbus-launch Hyprland";
    in
    {
      loginShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          ${exec}
        fi
      '';                                     # Start from TTY1

      variables = {
        #WLR_NO_HARDWARE_CURSORS="1";         # Needed for VM
        #WLR_RENDERER_ALLOW_SOFTWARE="1";
        XDG_CURRENT_DESKTOP="Hyprland";
        XDG_SESSION_TYPE="wayland";
        XDG_SESSION_DESKTOP="Hyprland";
      };
      sessionVariables = if hostName == "work" then {
        #GBM_BACKEND = "nvidia-drm";
        #__GL_GSYNC_ALLOWED = "0";
        #__GL_VRR_ALLOWED = "0";
        #WLR_DRM_NO_ATOMIC = "1";
        #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
        #_JAVA_AWT_WM_NONREPARENTING = "1";

        #QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        GDK_BACKEND = "wayland";
        WLR_NO_HARDWARE_CURSORS = "1";
        MOZ_ENABLE_WAYLAND = "1";
      } else {
        #QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        GDK_BACKEND = "wayland";
        WLR_NO_HARDWARE_CURSORS = "1";
        MOZ_ENABLE_WAYLAND = "1";
      };
      systemPackages = with pkgs; [
        grimblast       # Screenshot
        hyprpaper       # Wallpaper
        wl-clipboard    # Clipboard
        wlr-randr       # Monitor Settings
        xwayland        # X session
      ];
    };

    programs.hyprland = {
      enable = true;
    };

    security.pam.services.hyprlock.text = "auth include login";

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
          command = "${config.programs.hyprland.package}/bin/Hyprland"; # tuigreet not needed with exec-once hyprlock
          user = vars.user;
        };
      };
      vt = 7;
    };

    systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=no
      AllowSuspendThenHibernate=no
      AllowHybridSleep=yes
    '';                                       # Clamshell Mode

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };                                        # Cache

    home-manager.users.${vars.user} =
    let
      lid = if hostName == "xps" then "LID0" else "LID";
      lockScript = pkgs.writeShellScript "lock-script" ''
        action=$1
        ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
        if [ $? == 1 ]; then
          if [ "$action" == "lock" ]; then
            ${hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock
          elif [ "$action" == "suspend" ]; then
            ${pkgs.systemd}/bin/systemctl suspend
          fi
        fi
      '';
    in
    {
      imports = [
        hyprland.homeManagerModules.default
        hyprlock.homeManagerModules.hyprlock
        hypridle.homeManagerModules.hypridle
      ];

      programs.hyprlock = {
        enable = true;
        general = {
          hide_cursor = true;
          no_fade_in = false;
          disable_loading_bar = true;
          grace = 0;
        };
        backgrounds = [{
          monitor = "";
          path = ".config/wall.png";
          color = "rgba(25, 20, 20, 1.0)";
          blur_passes = 1;
          blur_size = 0;
          brightness = 0.2;
        }];
        input-fields = [
          {
            monitor = "";
            size = {
              width = 250;
              height = 60;
            };
            outline_thickness = 2;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = "rgba(0, 0, 0, 0)";
            inner_color = "rgba(0, 0, 0, 0.5)";
            font_color = "rgb(200, 200, 200)";
            fade_on_empty = false;
            placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
            hide_input = false;
            position = {
              x = 0;
              y = -120;
            };
            halign = "center";
            valign = "center";
          }
        ];
        labels = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 120;
            position = {
              x = 0;
              y = 80;
            };
            valign = "center";
            halign = "center";
          }
        ];
      };

      services.hypridle = {
        enable = true;
        beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
        afterSleepCmd = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on";
        ignoreDbusInhibit = true;
        lockCmd = "pidof ${hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock || ${hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
        listeners = [
          {
            timeout = 300;
            onTimeout = "${lockScript.outPath} lock";
          }
          {
            timeout = 1800;
            onTimeout = "${lockScript.outPath} suspend";
          }
        ];
      };

      wayland.windowManager.hyprland = with colors.scheme.default.hex; {
        enable = true;
        xwayland.enable = true;
        settings = {
          general = {
            border_size = 2;
            gaps_in = 3;
            gaps_out = 6;
            "col.active_border" = "0x99${active}";
            "col.inactive_border" = "0x66${inactive}";
            resize_on_border = true;
            layout = "dwindle";
          };
          decoration = {
            rounding = 6;
            active_opacity = 1;
            inactive_opacity = 1;
            fullscreen_opacity = 1;
            drop_shadow = false;
          };
          monitor = [
            ",preferred,auto,1,mirror,${toString mainMonitor}"
          ] ++ (if hostName == "beelink" || hostName == "h310m" then [
            "${toString mainMonitor},1920x1080@60,1920x0,1"
            "${toString secondMonitor},1920x1080@60,0x0,1"
          ] else if hostName == "work" then [
            "${toString mainMonitor},1920x1080@60,0x0,1"
            "${toString secondMonitor},1920x1200@60,1920x0,1"
            "${toString thirdMonitor},1920x1200@60,3840x0,1"
          ] else if hostName == "xps" then [
            "${toString mainMonitor},3840x2400@60,0x0,2"
            "${toString secondMonitor},1920x1080@60,1920x0,1"
          ] else [
            "${toString mainMonitor},1920x1080@60,0x0,1"
          ]);
          workspace = if hostName == "beelink" || hostName == "h310m" then [
            "${toString mainMonitor},1"
            "${toString mainMonitor},2"
            "${toString mainMonitor},3"
            "${toString mainMonitor},4"
            "${toString secondMonitor},5"
            "${toString secondMonitor},6"
            "${toString secondMonitor},7"
            "${toString secondMonitor},8"
          ] else if hostName == "xps" || hostName == "work" then [
            "${toString mainMonitor},1"
            "${toString mainMonitor},2"
            "${toString mainMonitor},3"
            "${toString secondMonitor},4"
            "${toString secondMonitor},5"
            "${toString secondMonitor},6"
          ] else [];
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
              "windowsOut, 1, 0.5, smoothOut"
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
            #kb_layout=us,us
            #kb_variant=,dvorak
            #kb_options=caps:ctrl_modifier
            kb_options = "caps:escape";
            follow_mouse = 2;
            repeat_delay = 250;
            numlock_by_default = 1;
            accel_profile = "flat";
            sensitivity = 0.8;
            touchpad = if hostName == "work" || hostName == "xps" || hostName == "probook" then {
              natural_scroll = true;
              scroll_factor = 0.2;
              middle_button_emulation = true;
              tap-to-click = true;
            } else {};
          };
          gestures = if hostName == "work"|| hostName == "xps" || hostName == "probook" then {
            workspace_swipe = true;
            workspace_swipe_fingers = 3;
            workspace_swipe_distance = 100;
            workspace_swipe_create_new = true;
            workspace_swipe_numbered = true;
          } else {};

          dwindle = {
            pseudotile = false;
            force_split = 2;
            preserve_split = true;
          };
          misc =  {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            background_color = "0x111111";
          };
          debug = {
            damage_tracking = 2;
          };
          bindm = [
            "SUPER,mouse:272,movewindow"
            "SUPER,mouse:273,resizewindow"
          ];
          bind = [
            "SUPER,Return,exec,${pkgs.${vars.terminal}}/bin/${vars.terminal}"
            "SUPER,Q,killactive,"
            "SUPER,Escape,exit,"
            "SUPER,S,exec,${pkgs.systemd}/bin/systemctl suspend"
            "SUPER,L,exec,${hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock"
            "SUPER,E,exec,GDK_BACKEND=x11 ${pkgs.pcmanfm}/bin/pcmanfm"
            "SUPER,F,togglefloating,"
            "SUPER,Space,exec, pkill wofi || ${pkgs.wofi}/bin/wofi --show drun"
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
            "ALT,1,workspace,1"
            "ALT,2,workspace,2"
            "ALT,3,workspace,3"
            "ALT,4,workspace,4"
            "ALT,5,workspace,5"
            "ALT,6,workspace,6"
            "ALT,7,workspace,7"
            "ALT,8,workspace,8"
            "ALT,9,workspace,9"
            "ALT,0,workspace,10"
            "ALT,right,workspace,+1"
            "ALT,left,workspace,-1"
            "ALTSHIFT,1,movetoworkspace,1"
            "ALTSHIFT,2,movetoworkspace,2"
            "ALTSHIFT,3,movetoworkspace,3"
            "ALTSHIFT,4,movetoworkspace,4"
            "ALTSHIFT,5,movetoworkspace,5"
            "ALTSHIFT,6,movetoworkspace,6"
            "ALTSHIFT,7,movetoworkspace,7"
            "ALTSHIFT,8,movetoworkspace,8"
            "ALTSHIFT,9,movetoworkspace,9"
            "ALTSHIFT,0,movetoworkspace,10"
            "ALTSHIFT,right,movetoworkspace,+1"
            "ALTSHIFT,left,movetoworkspace,-1"

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
            "SUPERCTRL,right,resizeactive,60 0"
            "SUPERCTRL,left,resizeactive,-60 0"
            "SUPERCTRL,up,resizeactive,0 -60"
            "SUPERCTRL,down,resizeactive,0 60"
          ];
          bindl = if hostName == "xps" || hostName == "work" then [
            ",switch:Lid Switch,exec,$HOME/.config/hypr/script/clamshell.sh"
          ] else [];
          windowrulev2 = [
            "float,title:^(Volume Control)$"
            "keepaspectratio,class:^(firefox)$,title:^(Picture-in-Picture)$"
            "noborder,class:^(firefox)$,title:^(Picture-in-Picture)$"
            "float, title:^(Picture-in-Picture)$"
            "size 24% 24%, title:(Picture-in-Picture)"
            "move 75% 75%, title:(Picture-in-Picture)"
            "pin, title:^(Picture-in-Picture)$"
            "float, title:^(Firefox)$"
            "size 24% 24%, title:(Firefox)"
            "move 74% 74%, title:(Firefox)"
            "pin, title:^(Firefox)$"
            "opacity 0.9, class:^(kitty)"
          ];
          exec-once = [
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "${hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock"
            "${pkgs.waybar}/bin/waybar"
            "${pkgs.eww-wayland}/bin/eww daemon"
            # "$HOME/.config/eww/scripts/eww"        # When running eww as a bar
            "${pkgs.blueman}/bin/blueman-applet"
            "${pkgs.swaynotificationcenter}/bin/swaync"
            "${pkgs.hyprpaper}/bin/hyprpaper"
          ] ++ (if hostName == "work" then [
            "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
            "${pkgs.rclone}/bin/rclone mount --daemon gdrive: /GDrive"
            # "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse /GDrive"
          ] else []) ++ (if hostName == "xps" then [
            "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
          ] else []);
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
                ${hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock
                ${pkgs.systemd}/bin/systemctl suspend
              fi
            fi
          '';
          executable = true;
        };
        ".config/hypr/hyprpaper.conf".text = ''
          preload = ~/.config/wall.png
          wallpaper = ,~/.config/wall.png
        '';
      };
    };
  };
}
