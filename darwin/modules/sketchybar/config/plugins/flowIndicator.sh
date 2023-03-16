#!/usr/bin/env sh
RUNNING=$(osascript -e 'if application "Flow" is running then return 0')
if [ "$RUNNING" == "" ]; then
  RUNNING=1
fi
TIME=""
if [ $RUNNING -eq 0 ]; then
   TIME=$(osascript -e 'tell application "Flow" to getTime')
   sketchybar --set $NAME label="$TIME" --set '/flow.*/' drawing=on
else
  sketchybar --set '/flow.*/' drawing=off
fi
