#!/bin/sh

entries="󰍃 Logout\n󰒲 Suspend\n Reboot\n⏻ Shutdown"

selected=$(echo -e $entries|wofi --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

case $selected in
  logout)
    exec hyprctl dispatch exit;;
  suspend)
    exec systemctl suspend;;
  reboot)
    exec systemctl reboot;;
  shutdown)
    exec systemctl poweroff -i;;
esac
