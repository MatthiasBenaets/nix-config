#
#  Sway Home manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#               └─ home.nix *
#

{ config, lib, pkgs, ... }:

{
  home.file = {
    ".config/hypr/hyprland.conf".text = ''
      monitor=,1920x1080@60,0x0,1

      input {
        kb_layout=us
        kb_variant=
        kb_model=
        kb_options=
        kb_rules=

        follow_mouse=0
        force_no_accel=1

        repeat_delay=250
        numlock_by_default=1

        touchpad {
          natural_scroll=1
        }
      }

      general {
        max_fps=60 # deprecated, unused
        sensitivity=0.25
        main_mod=SUPER

        gaps_in=5
        gaps_out=10
        border_size=2
        col.active_border=0x66ee1111
        col.inactive_border=0x66333333

        damage_tracking=full # leave it on full unless you hate your GPU and want to make it suffer
      }

      decoration {
        rounding=7
        multisample_edges=1
        active_opacity=0.95
        inactive_opacity=0.95
        fullscreen_opacity=1
        blur=1
        blur_size=3 # minimum 1
        blur_passes=1 # minimum 1, more passes = more resource intensive.
        # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
        # if you want heavy blur, you need to up the blur_passes.
        # the more passes, the more you can up the blur_size without noticing artifacts.
      }

      animations {
        enabled=1
        animation=windows,1,7,default
        animation=borders,1,10,default
        animation=fadein,1,10,default
        animation=workspaces,1,6,default
      }

      dwindle {
        pseudotile=0 # enable pseudotiling on dwindle
      }

      # example window rules
      # for windows named/classed as abc and xyz
      #windowrule=move 69 420,abc
      #windowrule=size 420 69,abc
      #windowrule=tile,xyz
      #windowrule=float,abc
      #windowrule=pseudo,abc
      #windowrule=monitor 0,xyz

      bind=SUPER,Return,exec,alacritty
      bind=SUPER,Q,killactive,
      bind=SUPER,Escape,exit,
      bind=SUPER,E,exec,pcmanfm
      bind=SUPER,H,togglefloating,
      #bind=SUPER,Space,exec,wofi --show drun -o DP-3
      bind=SUPER,Space,exec,rofi -show drun -o DP-3
      bind=SUPER,P,pseudo,

      bind=SUPER,left,movefocus,l
      bind=SUPER,right,movefocus,r
      bind=SUPER,up,movefocus,u
      bind=SUPER,down,movefocus,d

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

      bind=ALTSHIFT,exclam,movetoworkspace,1
      bind=ALTSHIFT,at,movetoworkspace,2
      bind=ALTSHIFT,numbersign,movetoworkspace,3
      bind=ALTSHIFT,dollar,movetoworkspace,4
      bind=ALTSHIFT,percent,movetoworkspace,5
      bind=ALTSHIFT,asciicircum,movetoworkspace,6
      bind=ALTSHIFT,ampersand,movetoworkspace,7
      bind=ALTSHIFT,asterisk,movetoworkspace,8
      bind=ALTSHIFT,parenleft,movetoworkspace,9
      bind=ALTSHIFT,parenright,movetoworkspace,10
      bind=ALTSHIFT,right,movetoworkspace,+1
      bind=ALTSHIFT,left,movetoworkspace,-1

      bind=CTRL,right,resizeactive,20 0
      bind=CTRL,left,resizeactive,-20 0
      bind=CTRL,up,resizeactive,0 -20
      bind=CTRL,down,resizeactive,0 20

      bind=,print,exec,flameshot gui

      bind=,XF86AudioLowerVolume,exec,pamixer -d 10
      bind=,XF86AudioRaiseVolume,exec,pamixer -i 10
      bind=,XF86AudioMute,exec,pamixer -t
      bind=,XF86AudioMicMute,exec,pamixer --default-source -t
      bind=,XF86MonBrightnessDown,exec,light -U 5
      bind=,XF86MonBrightnessUP,exec,light -A 5

      windowrule=float,rofi

      exec-once=swaybg -m center -i $HOME/.config/wall
      exec-once=waybar
    '';
  };
}
