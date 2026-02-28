{
  inputs,
  ...
}@flake:

let
  hyprlandPkg = { pkgs }: inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
in
{
  flake.modules.nixos.hyprland =
    {
      config,
      pkgs,
      ...
    }:
    let
      hyprland = hyprlandPkg { inherit pkgs; };
    in
    {
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
        package = hyprland;
      };

      security.pam.services.hyprlock = {
        text = "auth include login";
        enableGnomeKeyring = true;
      };

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${hyprland}/bin/Hyprland";
            user = config.host.user.name;
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

      home-manager.users.${config.host.user.name}.imports = [
        flake.config.flake.modules.homeManager.hyprland
      ];
    };

  flake.modules.homeManager.hyprland =
    {
      config,
      host,
      pkgs,
      ...
    }:
    let
      hyprland = hyprlandPkg { inherit pkgs; };

      m0 = builtins.head host.monitors;
      m1 = builtins.elemAt host.monitors 1;
      m2 = builtins.elemAt host.monitors 2;

      lid = "LID";
      lockScript = pkgs.writeShellScript "lock-script" ''
        action=$1
        if ! ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg -q "state: \"running\""; then
          if [ "$action" == "lock" ]; then
            # ${pkgs.hyprlock}/bin/hyprlock
            noctalia-shell ipc call lockscreen lock
          elif [ "$action" == "suspend" ]; then
            ${pkgs.systemd}/bin/systemctl suspend
          fi
        fi
      '';
    in
    {
      imports = [
        inputs.hyprland.homeManagerModules.default
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
            after_sleep_cmd = "${hyprland}/bin/hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "noctalia-shell ipc call lockScreen lock";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "${lockScript} lock";
            }
            {
              timeout = 1800;
              on-timeout = "${lockScript} suspend";
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

      wayland.windowManager.hyprland = {
        enable = true;
        package = hyprland;
        xwayland.enable = true;
        settings = {
          general = {
            border_size = 2;
            gaps_in = 3;
            gaps_out = 6;
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
            ",preferred,auto,1,mirror,${m0.name}"
          ]
          ++ (
            if host.name == "beelink" then
              [
                "${m0.name},${m0.w}x${m0.h}@${m0.refresh},${m0.x}x${m0.y},1"
                "${m1.name},${m1.w}x${m1.h}@${m1.refresh},${m1.x}x${m1.y},1"
              ]
            else if host.name == "work" then
              [
                "${m0.name},preferred,${m0.w}x${m0.h},1"
                "${m1.name},${m1.w}x${m1.h}@${m1.refresh},${m1.x}x${m1.y},1"
                "${m2.name},${m2.w}x${m2.h}@${m2.refresh},${m2.x}x${m2.y},1"
              ]
            else
              [
                "${m0.name},1920x1080@60,0x0,1"
              ]
          );
          workspace =
            if host.name == "beelink" then
              [
                "1, monitor:${m0.name}"
                "2, monitor:${m0.name}"
                "3, monitor:${m0.name}"
                "4, monitor:${m0.name}"
                "5, monitor:${m1.name}"
                "6, monitor:${m1.name}"
                "7, monitor:${m1.name}"
                "8, monitor:${m1.name}"
              ]
            else if host.name == "work" then
              [
                "1, monitor:${m0.name}"
                "2, monitor:${m0.name}"
                "3, monitor:${m0.name}"
                "4, monitor:${m1.name}"
                "5, monitor:${m1.name}"
                "6, monitor:${m1.name}"
              ]
            else
              [ ];
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
            # kb_variant=,dvorak
            kb_options = "caps:escape";
            follow_mouse = 2;
            repeat_delay = 250;
            numlock_by_default = 1;
            accel_profile = "adaptive";
            sensitivity = 0.5;
            natural_scroll = false;
            touchpad =
              if host.name == "work" then
                {
                  natural_scroll = true;
                  scroll_factor = 0.2;
                  middle_button_emulation = true;
                  tap-to-click = true;
                }
              else
                { };
          };
          device = {
            name = "matthias’s-magic-mouse";
            sensitivity = 0.5;
            natural_scroll = true;
          };
          cursor = {
            no_warps = true;
            no_hardware_cursors = true;
          };
          gestures =
            if host.name == "work" then
              {
                workspace_swipe = true;
                workspace_swipe_fingers = 3;
                workspace_swipe_distance = 100;
                workspace_swipe_create_new = true;
              }
            else
              { };
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
            focus_on_activate = true;
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
            "SUPER,Return,exec,${pkgs.kitty}/bin/kitty"
            "SUPER,Q,killactive,"
            "SUPER,Escape,exit,"
            "SUPER,S,exec,noctalia-shell ipc call lockScreen lock && ${pkgs.systemd}/bin/systemctl suspend"
            "SUPER,L,exec,noctalia-shell ipc call lockScreen lock"
            "SUPER,E,exec,${pkgs.thunar}/bin/thunar"
            "SUPERSHIFT,F,togglefloating,"
            "SUPER,Space,exec, noctalia-shell ipc call launcher toggle"
            "SUPER,P,pseudo,"
            ",F11,fullscreen,"
            "SUPER,R,forcerendererreload"
            "SUPERSHIFT,R,exec,${hyprland}/bin/hyprctl reload"
            "SUPER,T,exec,${pkgs.kitty}/bin/kitty -e nvim"
            "SUPER,K,exec,${hyprland}/bin/hyprctl switchxkblayout keychron-k8-keychron-k8 next"
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
            "SUPERSHIFT,4,exec,${pkgs.grimblast}/bin/grimblast --notify --freeze --wait 1 copysave area ~/Pictures/$(date +%Y-%m-%dT%H%M%S).png"
            ",XF86AudioLowerVolume,exec,${pkgs.pamixer}/bin/pamixer -d 10"
            ",XF86AudioRaiseVolume,exec,${pkgs.pamixer}/bin/pamixer -i 10"
            ",XF86AudioMute,exec,${pkgs.pamixer}/bin/pamixer -t"
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
            if host.name == "work" then
              [
                ",switch:Lid Switch,exec,$HOME/.config/hypr/script/clamshell.sh"
              ]
            else
              [ ];
          windowrule = [
            "match:title ^(Volume Control)$, float on"
            "match:class ^(firefox)$, match:title ^(Picture-in-Picture)$, keep_aspect_ratio on, border_size 0, float on, size 24% 24%, move 75% 75%, pin on"
            "match:class ^(kitty)$, opacity 0.9"
            "match:class (.*), idle_inhibit fullscreen"
          ];
          exec-once = [
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr"
            "noctalia-shell"
          ]
          ++ (
            if host.name == "work" then
              [
                "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
                "${pkgs.rclone}/bin/rclone mount --daemon gdrive: /GDrive --vfs-cache-mode=writes"
              ]
            else
              [ ]
          );
        };
      };

      home.file = {
        ".config/hypr/script/clamshell.sh" = {
          text = ''
            #!/bin/sh

            if grep open /proc/acpi/button/lid/${lid}/state; then
              ${hyprland}/bin/hyprctl keyword monitor "${m0.name}, ${m0.w}x${m0.h}, ${m0.x}x${m0.y}, 1"
            else
              if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
                ${hyprland}/bin/hyprctl keyword monitor "${m0.name}, disable"
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
}
