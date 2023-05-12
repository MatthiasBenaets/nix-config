#!/usr/bin/env sh

sketchybar --add item mail right                   \
           --set mail update_freq=60              \
                       width=57 \
					   icon=$MAIL \
					   icon.font="$FONT:Bold:16.0"  \
					   icon.color=$BLACK \
					   icon.background.color=$SKY \
					   icon.background.height=$ITEM_BACKGROUND_HEIGHT \
					   icon.background.corner_radius=$ITEM_CORNER_RADIUS \
					   icon.drawing=on \
                      script="$PLUGIN_DIR/mail.sh" \
                      label=!                      \
					  label.padding_left=20 \
                      background.color=$ITEM_COLOR  \
                      background.height=$ITEM_BACKGROUND_HEIGHT \
                      background.corner_radius=$ITEM_CORNER_RADIUS \
                      padding_left=0 \
                      padding_right=0
