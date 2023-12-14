{ config, lib, pkgs, vars, ... }:

let
  colors = import ../theming/colors.nix;
in
{
  config = lib.mkIf (config.wlwm.enable) {
    environment.systemPackages = with pkgs; [
      swaynotificationcenter
    ];

    home-manager.users.${vars.user} = {
      xdg.configFile = {
        "swaync/config.json".text = ''
          {
            "$schema": "/run/current-system/sw/etc/xdg/swaync/configSchema.json",
            "positionX": "right",
            "positionY": "top",
            "control-center-margin-top": 10,
            "control-center-margin-bottom": 10,
            "control-center-margin-right": 10,
            "control-center-margin-left": 10,
            "notification-icon-size": 64,
            "notification-body-image-height": 100,
            "notification-body-image-width": 200,
            "timeout": 10,
            "timeout-low": 5,
            "timeout-critical": 0,
            "fit-to-screen": false,
            "control-center-width": 400,
            "control-center-height": 1025,
            "notification-window-width": 400,
            "keyboard-shortcuts": true,
            "image-visibility": "when-available",
            "transition-time": 200,
            "hide-on-clear": false,
            "hide-on-action": true,
            "script-fail-notify": true,
            "widgets": [
              "title",
              "buttons-grid",
              "mpris",
              "volume",
              "backlight",
              "dnd",
              "notifications"
            ],
            "widget-config": {
              "title": {
                "text": "Notification Center",
                "clear-all-button": true,
                "button-text": "󰆴 Clear All"
              },
              "dnd": {
                "text": "Do Not Disturb"
              },
              "label": {
                "max-lines": 1,
                "text": "Notification Center"
              },
              "mpris": {
                "image-size": 96,
                "image-radius": 7
              },
              "volume": {
                "label": "󰕾"
              },
              "backlight": {
                "label": "󰃟"
              },
              "buttons-grid": {
                "actions": [
                  {
                    "label": "󰐥",
                    "command": "systemctl poweroff"
                  },
                  {
                    "label": "󰜉",
                    "command": "systemctl reboot"
                  },
                  {
                    "label": "󰒲",
                    "command": "systemctl suspend"
                  },
                  {
                    "label": "󰌾",
                    "command": "${pkgs.swaylock}/bin/swaylock"
                  },
                  {
                    "label": "󰍃",
                    "command": "${pkgs.hyprland}/bin/hyprctl dispatch exit"
                  },
                  {
                    "label": "󰕾",
                    "command": "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
                  },
                  {
                    "label": "󰍬",
                    "command": "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle"
                  },
                  {
                    "label": "󰂯",
                    "command": "${pkgs.blueman}/bin/blueman-manager"
                  },
                  {
                    "label": "󰹑",
                    "command": "${pkgs.grimblast}/bin/grimblast --notify --freeze --wait 1 copysave area ~/Pictures/$(date +%Y-%m-%dT%H%M%S).png"
                  },
                  {
                    "label": "",
                    "command": "${pkgs.kooha}/bin/kooha"
                  }
                ]
              }
            }
          }
        '';
        "swaync/style.css".text =  with colors.scheme.default; ''
          @define-color cc-bg rgba(${rgb.bg}, 0.95);
          @define-color noti-border-color rgba(255, 255, 255, 0.15);
          @define-color noti-bg rgb(17, 17, 27);
          @define-color noti-bg-darker rgb(43, 43, 57);
          @define-color noti-bg-hover rgb(27, 27, 43);
          @define-color noti-bg-focus rgba(27, 27, 27, 0.6);
          @define-color noti-close-bg rgba(255, 255, 255, 0.1);
          @define-color noti-close-bg-hover rgba(255, 255, 255, 0.15);
          @define-color text-color rgba(${rgb.fg}, 1);
          @define-color text-color-disabled rgb(150, 150, 150);
          @define-color bg-selected rgb(${rgb.fg});

          * {
            font-family: FiraCode Nerd Font Mono;
            font-weight: bolder;
          }

          .control-center .notification-row:focus,
          .control-center .notification-row:hover {
            opacity: 1;
            background: @noti-bg-darker
          }

          .notification-row {
            outline: none;
            margin: 10px;
            padding: 0;
          }

          .notification {
            background: transparent;
            padding: 0;
            margin: 0px;
          }

          .notification-content {
            background: @cc-bg;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #${hex.active};
            margin: 0;
          }

          .notification-default-action {
            margin: 0;
            padding: 0;
            border-radius: 5px;
          }

          .close-button {
            background: #${hex.red};
            color: @cc-bg;
            text-shadow: none;
            padding: 0;
            border-radius: 5px;
            margin-top: 5px;
            margin-right: 5px;
          }

          .close-button:hover {
            box-shadow: none;
            background: #${hex.red};
            transition: all .15s ease-in-out;
            border: none;
          }

          .notification-action {
            border: 2px solid #${hex.active};
            border-top: none;
            border-radius: 5px;
          }

          .notification-default-action:hover,
          .notification-action:hover {
            color: #${hex.fg};
            background: #${hex.fg};
          }

          .notification-default-action {
            border-radius: 5px;
            margin: 0px;
          }

          .notification-default-action:not(:only-child) {
            border-bottom-left-radius: 7px;
            border-bottom-right-radius: 7px;
          }

          .notification-action:first-child {
            border-bottom-left-radius: 10px;
            background: #1b1b2b;
          }

          .notification-action:last-child {
            border-bottom-right-radius: 10px;
            background: #1b1b2b;
          }

          .inline-reply {
            margin-top: 8px;
          }

          .inline-reply-entry {
            background: @noti-bg-darker;
            color: @text-color;
            caret-color: @text-color;
            border: 1px solid @noti-border-color;
            border-radius: 5px;
          }

          .inline-reply-button {
            margin-left: 4px;
            background: @noti-bg;
            border: 1px solid @noti-border-color;
            border-radius: 5px;
            color: @text-color;
          }

          .inline-reply-button:disabled {
            background: initial;
            color: @text-color-disabled;
            border: 1px solid transparent;
          }

          .inline-reply-button:hover {
            background: @noti-bg-hover;
          }

          .body-image {
            margin-top: 6px;
            background-color: #fff;
            border-radius: 5px;
          }

          .summary {
            font-size: 16px;
            font-weight: 700;
            background: transparent;
            color: rgba(${rgb.fg}, 1);
            text-shadow: none;
          }

          .time {
            font-size: 16px;
            font-weight: 700;
            background: transparent;
            color: @text-color;
            text-shadow: none;
            margin-right: 18px;
          }

          .body {
            font-size: 15px;
            font-weight: 400;
            background: transparent;
            color: @text-color;
            text-shadow: none;
          }

          .control-center {
            background: @cc-bg;
            border: 2px solid #${hex.active};
            border-radius: 5px;
          }

          .control-center-list {
            background: transparent;
          }

          .control-center-list-placeholder {
            opacity: .5;
          }

          .floating-notifications {
            background: transparent;
          }

          .blank-window {
            background: alpha(black, 0.1);
          }

          .widget-title {
            color: #${hex.fg};
            background: @noti-bg-darker;
            padding: 5px 10px;
            margin: 10px 10px 5px 10px;
            font-size: 1.5rem;
            border-radius: 5px;
          }

          .widget-title>button {
            font-size: 1rem;
            color: @text-color;
            text-shadow: none;
            background: @noti-bg;
            box-shadow: none;
            border-radius: 5px;
          }

          .widget-title>button:hover {
            background: #${hex.red};
            color: @cc-bg;
          }

          .widget-dnd {
            background: @noti-bg-darker;
            padding: 5px 10px;
            margin: 10px 10px 5px 10px;
            border-radius: 5px;
            font-size: large;
            color: #${hex.fg};
          }

          .widget-dnd>switch {
            border-radius: 5px;
            background: #${hex.fg};
          }

          .widget-dnd>switch:checked {
            background: #${hex.red};
            border: 1px solid #${hex.red};
          }

          .widget-dnd>switch slider {
            background: @cc-bg;
            border-radius: 5px;
          }

          .widget-dnd>switch:checked slider {
            background: @cc-bg;
            border-radius: 5px;
          }

          .widget-label {
            margin: 10px 10px 5px 10px;
          }

          .widget-label>label {
            font-size: 1rem;
            color: @text-color;
          }

          .widget-mpris {
            color: @text-color;
            background: @noti-bg-darker;
            padding: 5px 10px;
            margin: 10px 10px 5px 10px;
            border-radius: 5px;
          }

          .widget-mpris > box > button {
            border-radius: 5px;
          }

          .widget-mpris-player {
            padding: 5px 10px;
            margin: 10px;
          }

          .widget-mpris-title {
            font-weight: 700;
            font-size: 1.25rem;
          }

          .widget-mpris-subtitle {
            font-size: 1.1rem;
          }

          .widget-buttons-grid {
            font-size: x-large;
            padding: 0px;
            margin: 10px 10px 5px 10px;
            border-radius: 5px;
            background: @noti-bg-darker;
          }

          .widget-buttons-grid>flowbox>flowboxchild>button {
            margin: 0px;
            background: @cc-bg;
            border-radius: 5px;
            color: @text-color;
          }

          .widget-buttons-grid>flowbox>flowboxchild>button:hover {
            background: rgba(${rgb.fg}, 1);
            color: @cc-bg;
          }

          .widget-menubar>box>.menu-button-bar>button {
            border: none;
            background: transparent;
          }

          .topbar-buttons>button {
            border: none;
            background: transparent;
          }

          .widget-volume {
            background: @noti-bg-darker;
            padding: 5px;
            margin: 10px 10px 5px 10px;
            border-radius: 5px;
            font-size: x-large;
            color: @text-color;
          }

          .widget-volume>box>button {
            background: #${hex.active};
            border: none;
          }

          .per-app-volume {
            background-color: @noti-bg;
            padding: 4px 8px 8px;
            margin: 0 8px 8px;
            border-radius: 5px;
          }

          .widget-backlight {
            background: @noti-bg-darker;
            padding: 5px;
            margin: 10px 10px 5px 10px;
            border-radius: 5px;
            font-size: x-large;
            color: @text-color;
          }

          trough {
            background: #${hex.fg};
          }

          highlight{
            background: #${hex.active};
          }
        '';
      };
    };
  };
}
