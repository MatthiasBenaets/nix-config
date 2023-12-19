#
#  Hyprland Configuration
#  Enable with "hyprland.enable = true;"
#

{ config, lib, system, pkgs, hyprland, vars, host, ... }:

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

        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        GDK_BACKEND = "wayland";
        WLR_NO_HARDWARE_CURSORS = "1";
        MOZ_ENABLE_WAYLAND = "1";
      } else {
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        GDK_BACKEND = "wayland";
        WLR_NO_HARDWARE_CURSORS = "1";
        MOZ_ENABLE_WAYLAND = "1";
      };
      systemPackages = with pkgs; [
        grimblast       # Screenshot
        swayidle        # Idle Daemon
        swaylock        # Lock Screen
        wl-clipboard    # Clipboard
        wlr-randr       # Monitor Settings
      ];
    };

    security.pam.services.swaylock = {
      text = ''
       auth include login
      '';
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
        };
      };
      vt = 7;
    };

    programs = {
      hyprland = {                            # Window Manager
        enable = true;
        package = hyprland.packages.${pkgs.system}.hyprland;
        #nvidiaPatches = if hostName == "work" then true else false;
      };
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
      touchpad =
        if hostName == "laptop" || hostName == "work" then ''
            touchpad {
              natural_scroll=true
              middle_button_emulation=true
              tap-to-click=true
            }
          }
          '' else "";
      gestures =
        if hostName == "laptop" || hostName == "work" then ''
          gestures {
            workspace_swipe=true
            workspace_swipe_fingers=3
            workspace_swipe_distance=100
          }
        '' else "";
      workspaces =
        if hostName == "desktop" || hostName == "beelink" then ''
          monitor=${toString mainMonitor},1920x1080@60,1920x0,1
          monitor=${toString secondMonitor},1920x1080@60,0x0,1
        '' else if hostName == "work" then ''
          monitor=${toString mainMonitor},1920x1080@60,0x0,1
          monitor=${toString secondMonitor},1920x1200@60,1920x0,1
          monitor=${toString thirdMonitor},1920x1200@60,3840x0,1
        '' else ''
          monitor=${toString mainMonitor},1920x1080@60,0x0,1
        '';
      monitors =
        if hostName == "desktop" || hostName == "beelink" then ''
          workspace=${toString mainMonitor},1
          workspace=${toString mainMonitor},2
          workspace=${toString mainMonitor},3
          workspace=${toString mainMonitor},4
          workspace=${toString secondMonitor},5
          workspace=${toString secondMonitor},6
          workspace=${toString secondMonitor},7
          workspace=${toString secondMonitor},8
        '' else if hostName == "work" then ''
          workspace=${toString mainMonitor},1
          workspace=${toString mainMonitor},2
          workspace=${toString mainMonitor},3
          workspace=${toString secondMonitor},4
          workspace=${toString secondMonitor},5
          workspace=${toString secondMonitor},6
          workspace=${toString thirdMonitor},7

          bindl=,switch:Lid Switch,exec,$HOME/.config/hypr/script/clamshell.sh
        '' else "";
      execute =
        if hostName == "desktop" || hostName == "beelink" then ''
          exec-once=${pkgs.swayidle}/bin/swayidle -w timeout 600 '${pkgs.swaylock}/bin/swaylock -f' timeout 1200 '${pkgs.systemd}/bin/systemctl suspend' after-resume '${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on' before-sleep '${pkgs.swaylock}/bin/swaylock -f && ${config.programs.hyprland.package}/bin/hyprctl dispatch dpms off'
        '' else if hostName == "work" then ''
          exec-once=${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
          #exec-once=${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse /GDrive
          exec-once=${pkgs.rclone}/bin/rclone mount --daemon gdrive: /GDrive
          exec-once=${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.swaylock}/bin/swaylock -f' timeout 600 '${pkgs.systemd}/bin/systemctl suspend' after-resume '${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on' before-sleep '${pkgs.swaylock}/bin/swaylock -f && ${config.programs.hyprland.package}/bin/hyprctl dispatch dpms off'
        '' else "";
    in
    let
      hyprlandConf = with colors.scheme.default.hex; ''
        ${workspaces}
        ${monitors}
        monitor=,preferred,auto,1,mirror,${toString mainMonitor}

        general {
          border_size=2
          gaps_in=0
          gaps_out=0
          col.active_border=0x99${active}
          col.inactive_border=0x66${inactive}
          layout=dwindle
        }

        decoration {
          rounding=0
          active_opacity=1
          inactive_opacity=1
          fullscreen_opacity=1
          drop_shadow=false
        }

        animations {
          enabled = false
          bezier = overshot, 0.05, 0.9, 0.1, 1.05
          bezier = smoothOut, 0.5, 0, 0.99, 0.99
          bezier = smoothIn, 0.5, -0.5, 0.68, 1.5
          bezier = rotate,0,0,1,1
          animation = windows, 1, 4, overshot, slide
          animation = windowsIn, 1, 2, smoothOut
          animation = windowsOut, 1, 0.5, smoothOut
          animation = windowsMove, 1, 3, smoothIn, slide
          animation = border, 1, 5, default
          animation = fade, 1, 4, smoothIn
          animation = fadeDim, 1, 4, smoothIn
          animation = workspaces, 1, 4, default
          animation = borderangle, 1, 20, rotate, loop
        }

        input {
          kb_layout=us,us
          #kb_options=caps:ctrl_modifier
          kb_variant=,dvorak
          follow_mouse=2
          repeat_delay=250
          numlock_by_default=1
          accel_profile=flat
          sensitivity=0.8
          ${touchpad}
        }

        ${gestures}

        dwindle {
          pseudotile=false
          force_split=2
          preserve_split=true
        }

        misc {
          disable_hyprland_logo=true
          disable_splash_rendering=true
          mouse_move_enables_dpms=true
          key_press_enables_dpms=true
          background_color=0x111111
        }

        debug {
          damage_tracking=2
        }

        bindm=SUPER,mouse:272,movewindow
        bindm=SUPER,mouse:273,resizewindow

        bind=SUPER,Return,exec,${pkgs.${vars.terminal}}/bin/${vars.terminal}
        bind=SUPER,Q,killactive,
        bind=SUPER,Escape,exit,
        bind=SUPER,S,exec,${pkgs.systemd}/bin/systemctl suspend
        bind=SUPER,L,exec,${pkgs.swaylock}/bin/swaylock
        bind=SUPER,E,exec,GDK_BACKEND=x11 ${pkgs.pcmanfm}/bin/pcmanfm
        bind=SUPER,F,togglefloating,
        bind=SUPER,Space,exec, pkill wofi || ${pkgs.wofi}/bin/wofi --show drun
        bind=SUPER,P,pseudo,
        bind=,F11,fullscreen,
        bind=SUPER,R,forcerendererreload
        bind=SUPERSHIFT,R,exec,${pkgs.hyprland}/bin/hyprctl reload
        bind=SUPER,T,exec,${pkgs.${vars.terminal}}/bin/${vars.terminal} -e nvim
        bind=SUPER,K,exec,${pkgs.hyprland}/bin/hyprctl switchxkblayout keychron-k8-keychron-k8 next

        bind=SUPER,left,movefocus,l
        bind=SUPER,right,movefocus,r
        bind=SUPER,up,movefocus,u
        bind=SUPER,down,movefocus,d

        bind=SUPERSHIFT,left,movewindow,l
        bind=SUPERSHIFT,right,movewindow,r
        bind=SUPERSHIFT,up,movewindow,u
        bind=SUPERSHIFT,down,movewindow,d

        bind=ALT,1,workspace,1
        bind=ALT,2,workspace,2
        bind=ALT,3,workspace,3
        bind=ALT,4,workspace,4
        bind=ALT,5,workspace,5
        bind=ALT,6,workspace,6
        bind=ALT,7,workspace,7
        bind=ALT,8,workspace,8
        bind=ALT,9,workspace,9
        bind=ALT,0,workspace,10
        bind=ALT,right,workspace,+1
        bind=ALT,left,workspace,-1

        bind=ALTSHIFT,1,movetoworkspace,1
        bind=ALTSHIFT,2,movetoworkspace,2
        bind=ALTSHIFT,3,movetoworkspace,3
        bind=ALTSHIFT,4,movetoworkspace,4
        bind=ALTSHIFT,5,movetoworkspace,5
        bind=ALTSHIFT,6,movetoworkspace,6
        bind=ALTSHIFT,7,movetoworkspace,7
        bind=ALTSHIFT,8,movetoworkspace,8
        bind=ALTSHIFT,9,movetoworkspace,9
        bind=ALTSHIFT,0,movetoworkspace,10
        bind=ALTSHIFT,right,movetoworkspace,+1
        bind=ALTSHIFT,left,movetoworkspace,-1

        binde=SUPERCTRL,right,resizeactive,60 0
        binde=SUPERCTRL,left,resizeactive,-60 0
        binde=SUPERCTRL,up,resizeactive,0 -60
        binde=SUPERCTRL,down,resizeactive,0 60

        # bind=SUPER,M,submap,resize
        # submap=resize
        # binde=,right,resizeactive,20 0
        # binde=,left,resizeactive,-20 0
        # binde=,up,resizeactive,0 -20
        # binde=,down,resizeactive,0 20
        # bind=,escape,submap,reset
        # submap=reset

        bind=SUPER,Z,layoutmsg,togglesplit

        bind=,print,exec,${pkgs.grimblast}/bin/grimblast --notify --freeze --wait 1 copysave area ~/Pictures/$(date +%Y-%m-%dT%H%M%S).png
        bind=,XF86AudioLowerVolume,exec,${pkgs.pamixer}/bin/pamixer -d 10
        bind=,XF86AudioRaiseVolume,exec,${pkgs.pamixer}/bin/pamixer -i 10
        bind=,XF86AudioMute,exec,${pkgs.pamixer}/bin/pamixer -t
        bind=SUPER_L,c,exec,${pkgs.pamixer}/bin/pamixer --default-source -t
        bind=,XF86AudioMicMute,exec,${pkgs.pamixer}/bin/pamixer --default-source -t
        bind=,XF86MonBrightnessDown,exec,${pkgs.light}/bin/light -U 10
        bind=,XF86MonBrightnessUP,exec,${pkgs.light}/bin/light -A 10

        windowrulev2=float,title:^(Volume Control)$
        windowrulev2 = float, title:^(Picture-in-Picture)$
        windowrulev2 = size 24% 24%, title:(Picture-in-Picture)
        windowrulev2 = move 75% 75%, title:(Picture-in-Picture)
        windowrulev2 = pin, title:^(Picture-in-Picture)$
        windowrulev2 = float, title:^(Firefox)$
        windowrulev2 = size 24% 24%, title:(Firefox)
        windowrulev2 = move 74% 74%, title:(Firefox)
        windowrulev2 = pin, title:^(Firefox)$

        exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once=${pkgs.waybar}/bin/waybar
        exec-once=${pkgs.eww-wayland}/bin/eww daemon
        #exec-once=$HOME/.config/eww/scripts/eww        # When running eww as a bar
        exec-once=${pkgs.blueman}/bin/blueman-applet
        exec-once=${pkgs.swaynotificationcenter}/bin/swaync
        ${execute}
      '';
    in
    {
      xdg.configFile."hypr/hyprland.conf".text = hyprlandConf;

      programs.swaylock.settings = {
        #image = "$HOME/.config/wall";
        color = "000000f0";
        font-size = "24";
        indicator-idle-visible = false;
        indicator-radius = 100;
        indicator-thickness = 20;
        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        key-hl-color = "79b360";
        line-color = "000000f0";
        line-clear-color = "000000f0";
        line-ver-color = "000000f0";
        line-wrong-color = "000000f0";
        ring-color = "ffffff50";
        ring-clear-color = "bbbbbb50";
        ring-ver-color = "bbbbbb50";
        ring-wrong-color = "b3606050";
        text-color = "ffffff";
        text-ver-color = "ffffff";
        text-wrong-color = "ffffff";
        show-failed-attempts = true;
      };

      home.file = {
        ".config/hypr/script/clamshell.sh" = {
          text = ''
            #!/bin/sh

            if grep open /proc/acpi/button/lid/LID/state; then
              ${config.programs.hyprland.package}/bin/hyprctl keyword monitor "eDP-1, 1920x1080, 0x0, 1"
            else
              if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
                ${config.programs.hyprland.package}/bin/hyprctl keyword monitor "eDP-1, disable"
              else
                ${pkgs.swaylock}/bin/swaylock -f
                ${pkgs.systemd}/bin/systemctl sleep
              fi
            fi
          '';
          executable = true;
        };
      };
    };
  };
}
