#!/bin/sh

update() {
  source "$HOME/.config/sketchybar/colors.sh"
  COLOR=$SPACE_DESELECTED
  if [ "$SELECTED" = "true" ]; then
      COLOR=$SPACE_SELECTED
  fi
  sketchybar --animate tanh 15 --set $NAME icon.highlight=$SELECTED label.highlight=$SELECTED background.color=$COLOR
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    yabai -m space --destroy $SID
    sketchybar --trigger --trigger windows_on_spaces --trigger space_change
  else
    yabai -m space --focus $SID 2>/dev/null
  fi
}

case "$SENDER" in
  "mouse.entered") mouse_entered
  ;;
  "mouse.exited") mouse_exited
  ;;
  "mouse.clicked") mouse_clicked
  ;;
  *) update
  ;;
esac
