#!/bin/bash

SPACE_ICONS=("z" "a" "s" "d" "f" "1" "2" "3" "4")

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))

  space=(
    associated_space=$sid
    icon="${SPACE_ICONS[i]}"
    icon.padding_left=5
    icon.padding_right=5
    padding_left=2
    padding_right=2
    label.padding_right=15
    icon.color=$SPACE_SELECTED
    icon.highlight_color=$SPACE_DESELECTED
    label.color=$SPACE_SELECTED
    label.highlight_color=$SPACE_DESELECTED
    label.font="sketchybar-app-font:Regular:12.0"
    label.y_offset=-1
    background.color=$SPACE_BACKGROUND2
    background.drawing=off
    background.height=20
    background.corner_radius=$ITEM_CORNER_RADIUS
    label.drawing=off
    script="$PLUGIN_DIR/space.sh"
  )

  sketchybar --add space space.$sid left    \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid mouse.clicked
done

spaces_bracket=(
  background.color=$SPACE_BACKGROUND
  background.corner_radius=$ITEM_CORNER_RADIUS
)

# separator=(
#   icon=􀆊
#   icon.font="$FONT:Heavy:16.0"
#   padding_left=10
#   padding_right=8
#   label.drawing=off
#   associated_display=active
#   click_script='yabai -m space --create && sketchybar --trigger space_change'
#   icon.color=$WHITE
# )

sketchybar --add bracket spaces_bracket '/space\..*/'  \
           --set spaces_bracket "${spaces_bracket[@]}" 
           # --add item separator left                   \
           # --set separator "${separator[@]}"
