#!/bin/sh

case $1 in
	"status")
		#MUTED=$(pacmd list-sources | awk '/\*/,EOF {print}' | awk '/muted/ {print $2; exit}')
		#if [[ $MUTED = "no" ]]; then
  		MUTED=$(awk -F"[][]" '/Left:/ { print $4 }' <(amixer sget Capture))
		if [[ $MUTED = "on" ]]; then
			echo ''
		else
  			echo ''
		fi
		;;
	"toggle")
		#ID=$(pacmd list-sources | grep "*\ index:" | cut -d' ' -f5)
		#pactl set-source-mute $ID toggle
		amixer set Capture toggle
		;;
esac
