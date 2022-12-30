#
#  Hyprland Home-manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#               └─ home.nix *
#

{ config, lib, pkgs, host, ... }:

let
  confFile = with host; ''
    MONITORS

    general {
      sensitivity=1
      main_mod=SUPER
      border_size=3
      gaps_in=5
      gaps_out=7
      col.active_border=0x80ffffff
      col.inactive_border=0x66333333
      layout=dwindle
    }

    decoration {
      rounding=5
      multisample_edges=true
      active_opacity=0.93
      inactive_opacity=0.93
      fullscreen_opacity=1
      blur=true
      drop_shadow=false
    }

    animations {
      enabled=true
      bezier = myBezier,0.1,0.7,0.1,1.05
      animation=fade,1,7,default
      animation=windows,1,7,myBezier
      animation=windowsOut,1,3,default,popin 60%
      animation=windowsMove,1,7,myBezier
    }

    input {
      kb_layout=us
      kb_options=caps:ctrl_modifier
      follow_mouse=2
      repeat_delay=250
      numlock_by_default=1
      force_no_accel=1
      sensitivity=1
    }

    dwindle {
      pseudotile=false
      force_split=2
    }

    debug {
      damage_tracking=2
    }

    bindm=SUPER,mouse:272,movewindow
    bindm=SUPER,mouse:273,resizewindow

    bind=SUPER,Return,exec,${pkgs.alacritty}/bin/alacritty
    bind=SUPER,Q,killactive,
    bind=SUPER,Escape,exit,
    bind=SUPER,E,exec,${pkgs.pcmanfm}/bin/pcmanfm
    bind=SUPER,H,togglefloating,
    bind=SUPER,Space,exec,${pkgs.rofi}/bin/rofi -show drun
    bind=SUPER,P,pseudo,
    bind=SUPER,F,fullscreen,
    bind=SUPER,R,forcerendererreload
    bind=SUPERSHIFT,R,exec,${pkgs.hyprland}/bin/hyprctl reload
    bind=SUPER,T,exec,${pkgs.emacs}/bin/emacs

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

    bind=CTRL,right,resizeactive,20 0
    bind=CTRL,left,resizeactive,-20 0
    bind=CTRL,up,resizeactive,0 -20
    bind=CTRL,down,resizeactive,0 20

    bind=,print,exec,${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f - -o ~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png && notify-send "Saved to ~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"

    bind=,XF86AudioLowerVolume,exec,${pkgs.pamixer}/bin/pamixer -d 10
    bind=,XF86AudioRaiseVolume,exec,${pkgs.pamixer}/bin/pamixer -i 10
    bind=,XF86AudioMute,exec,${pkgs.pamixer}/bin/pamixer -t
    bind=,XF86AudioMicMute,exec,${pkgs.pamixer}/bin/pamixer --default-source -t
    bind=,XF86MonBrightnessDown,exec,${pkgs.light}/bin/light -U 5
    bind=,XF86MonBrightnessUP,exec,${pkgs.light}/bin/light -A 5

    windowrule=float,^(Rofi)$
    windowrule=float,title:^(Volume Control)$
    windowrule=float,title:^(Picture-in-Picture)$
    windowrule=pin,title:^(Picture-in-Picture)$
    windowrule=move 75% 75% ,title:^(Picture-in-Picture)$
    windowrule=size 24% 24% ,title:^(Picture-in-Picture)$

    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    #exec-once=${pkgs.swaybg}/bin/swaybg -m center -i $HOME/.config/wall
    exec-once=${pkgs.mpvpaper}/bin/mpvpaper -sf -v -o "--loop --panscan=1" '*' $HOME/.config/wall.mp4
    exec-once=${pkgs.waybar}/bin/waybar
    exec-once=${pkgs.blueman}/bin/blueman-applet
  '';

  hyprlandConf = with host; builtins.replaceStrings ["MONITORS"]
    [
      (if hostName == "desktop" then ''
        monitor=${toString mainMonitor},1920x1080@60,1920x0,1
        monitor=${toString secondMonitor},1920x1080@60,0x0,1

        workspace=${toString mainMonitor},1
        workspace=${toString secondMonitor},6

        wsbind=1,${toString mainMonitor}
        wsbind=2,${toString mainMonitor}
        wsbind=3,${toString mainMonitor}
        wsbind=4,${toString mainMonitor}
        wsbind=5,${toString mainMonitor}
        wsbind=6,${toString secondMonitor}
        wsbind=7,${toString secondMonitor}
        wsbind=8,${toString secondMonitor}
        wsbind=9,${toString secondMonitor}
        wsbind=10,${toString secondMonitor}
      ''
      else if hostName == "laptop" || hostname == "vm" then ''
        monitor=${toString mainMonitor},1920x1080@60,0x0,1
      ''
      else false)
    ]
    "${confFile}";
in
{
  #xdg.configFile."hypr/hyprland.conf".text = "${hyprlandConf}";
  xdg.configFile."hypr/hyprland.conf".text = hyprlandConf;
}
