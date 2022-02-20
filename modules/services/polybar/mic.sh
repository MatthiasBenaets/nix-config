#!/bin/sh

MUTED=$(pacmd list-sources | awk '/\*/,EOF {print}' | awk '/muted/ {print $2; exit}')

if [ $MUTED = "no" ]; then
  echo ''
else
  echo ''
fi
