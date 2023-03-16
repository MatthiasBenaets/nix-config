#!/usr/bin/env sh
RUNNING=$(osascript -e 'if application "Flow" is running then return 0')
if [ "$RUNNING" == "" ]; then
  RUNNING=1
fi
PHASE=""
if [ $RUNNING -eq 0 ]; then
   PHASE=$(osascript -e 'tell application "Flow" to getPhase')
   if [ $PHASE == "Flow" ]; then
      PHASE_ICON=""
   elif [ $PHASE == "Break" ]; then
      PHASE_ICON="鈴"
   fi
   sketchybar --set $NAME  --set icon=$PHASE_ICON '/flow.*/' drawing=on
else
  sketchybar --set '/flow.*/' drawing=off
fi
