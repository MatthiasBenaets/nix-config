#!/usr/bin/env sh

LABEL=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk 'NR==13 {print $2}')

sketchybar --set $NAME label=$LABEL
