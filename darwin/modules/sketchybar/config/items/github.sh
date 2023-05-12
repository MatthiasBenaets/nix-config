#!/usr/bin/env sh

sketchybar --add       item            github.bell right                  \
           --set       github.bell     update_freq=180                    \
                                       label=$LOADING                     \
                                       label.highlight_color=$BLUE        \
                                       popup.align=right                  \
                                       background.padding_right=10        \
                                       script="$PLUGIN_DIR/github.sh"     \
                                       click_script="$POPUP_CLICK_SCRIPT" \
           --add       item            github_logo right \
           --set       github_logo     icon.font="$FONT:Bold:15.0"        \
                                       icon=$BELL                         \
                                       icon.color=$BLACK                  \
                                       label.drawing=off                  \
                                       background.color=$PINK             \
                                       background.height=26                
           --subscribe github.bell     mouse.entered                      \
                                       mouse.exited                       \
                                       mouse.exited.global                \
                                                                          \
           --add       item            github.template popup.github.bell  \
           --set       github.template drawing=off                        \
                                       background.corner_radius=12        \
                                       background.padding_left=7          \
                                       background.padding_right=7         \
                                       background.color=$BLACK            \
                                       background.drawing=off             \
                                       icon.background.height=2           \
                                       icon.background.y_offset=-12
