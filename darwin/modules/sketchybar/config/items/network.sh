#!/usr/bin/env sh

sketchybar -m --add item network_up right \
              --set network_up label.font="$FONT:Bold:8.0" \
                               icon.font="$FONT:Bold:8.0" \
                               icon=􀆇 \
                               icon.highlight_color=$BLUE \
                               y_offset=5 \
                               width=0 \
                               update_freq=1 \
                               script="$PLUGIN_DIR/network.sh" \
              --add item network_down right \
              --set network_down label.font="$FONT:Bold:8.0" \
                                 icon.font="$FONT:Bold:8.0" \
                                 icon=􀆈 \
                                 icon.highlight_color=$YELLOW \
                                 y_offset=-5 \
                                 update_freq=1\

sketchybar --add bracket network_info network_up network_down \
           --set network_info background.color=$ITEM_COLOR  \
                              background.corner_radius=$ITEM_CORNER_RADIUS \
                              background.height=$ITEM_BACKGROUND_HEIGHT \
                              background.padding_right=$ITEM_PADDING \
                              background.padding_left=0
