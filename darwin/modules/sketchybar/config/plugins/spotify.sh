#!/usr/bin/env sh

next ()
{
  osascript -e 'tell application "Music" to play next track'
}

back () 
{
  osascript -e 'tell application "Music" to play previous track'
}

play () 
{
  osascript -e 'tell application "Music" to playpause'
}

repeat () 
{
  REPEAT=$(osascript -e 'tell application "Music" to get repeating')
  if [ "$REPEAT" = "false" ]; then
    sketchybar -m --set music.repeat icon.highlight=on
    osascript -e 'tell application "Music" to set repeating to true'
  else 
    sketchybar -m --set music.repeat icon.highlight=off
    osascript -e 'tell application "Music" to set repeating to false'
  fi
}

shuffle () 
{
  SHUFFLE=$(osascript -e 'tell application "Music" to get shuffling')
  if [ "$SHUFFLE" = "false" ]; then
    sketchybar -m --set music.shuffle icon.highlight=on
    osascript -e 'tell application "Music" to set shuffling to true'
  else 
    sketchybar -m --set music.shuffle icon.highlight=off
    osascript -e 'tell application "Music" to set shuffling to false'
  fi
}

update ()
{
  PLAYING=1
  if [ "$(echo "$INFO" | jq -r '.["Player State"]')" = "Playing" ]; then
    PLAYING=0
    TRACK="$(echo "$INFO" | jq -r .Name | cut -c1-25)"
    ARTIST="$(echo "$INFO" | jq -r .Artist | cut -c1-25)"
    ALBUM="$(echo "$INFO" | jq -r .Album | cut -c1-25)"
    SHUFFLE=$(osascript -e 'tell application "Music" to get shuffling')
    REPEAT=$(osascript -e 'tell application "Music" to get repeating')
    COVER=$(osascript -e 'tell application "Music" to get artwork url of current track')
  fi

  args=()
  if [ $PLAYING -eq 0 ]; then
    curl -s --max-time 20 "$COVER" -o /tmp/cover.jpg
    if [ "$ARTIST" == "" ]; then
      args+=(--set music.title label="$TRACK" drawing=on \
             --set music.artist label="$ALBUM" drawing=on )
    else
      args+=(--set music.title label="$TRACK" drawing=on \
             --set music.artist label="$ARTIST" drawing=on)
    fi
    args+=(--set music.play icon=􀊆 \
           --set music.shuffle icon.highlight=$SHUFFLE \
           --set music.repeat icon.highlight=$REPEAT \
           --set music.cover popup.background.image="/tmp/cover.jpg" \
                               popup.background.color=0x000000 \
           --set music drawing=on                                     )
  else
    args+=(--set music.title drawing=off \
           --set music.artist drawing=off \
           --set music.cover popup.drawing=off \
           --set music.play icon=􀊄              )
  fi
  sketchybar -m "${args[@]}"
}

mouse_clicked () {
  case "$NAME" in
    "music.next") next
    ;;
    "music.back") back
    ;;
    "music.play") play
    ;;
    "music.shuffle") shuffle
    ;;
    "music.repeat") repeat
    ;;
    *) exit
    ;;
  esac
}

popup () {
  sketchybar --set music.cover popup.drawing=$1
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "mouse.entered") popup on
  ;;
  "mouse.exited"|"mouse.exited.global") popup off
  ;;
  *) update
  ;;
esac
