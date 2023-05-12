#!/usr/bin/env sh
sketchybar --add item     calendar right               \
           --set calendar width=135                    \
           icon=cal                     \
                          icon.color=$LABEL_COLOR            \
                          icon.font="$FONT:Black:12.0" \
                          icon.padding_left=5         \
                          icon.padding_right=5         \
                          label.color=$LABEL_COLOR           \
                          label.padding_left=5        \
                          label.padding_right=5       \
                          background.color=$TRANSPARENT  \
                          update_freq=30                    \
                          script="$PLUGIN_DIR/calendar.sh"  \
           --subscribe    calendar system_woke
sketchybar --add item calendar_logo right \
           --set calendar_logo icon=$CALENDAR \
                 icon.font="$FONT:Bold:16.0"  \
                 icon.color=$BLACK \
                 width=30          \
                 align=center \
                 label.drawing=off \
                 background.height=$ITEM_BACKGROUND_HEIGHT \
                 background.color=$YELLOW \
                 background.corner_radius=$ITEM_CORNER_RADIUS \
                 padding_left=0 \
                 padding_right=0

sketchybar --add bracket calendar_info calendar calendar_logo \
           --set calendar_info background.color=$ITEM_COLOR \
                               background.corner_radius=$ITEM_CORNER_RADIUS \
                               background.height=$ITEM_BACKGROUND_HEIGHT \
                               background.padding_right=$ITEM_PADDING \
                               background.padding_left=0
