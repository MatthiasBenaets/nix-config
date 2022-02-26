#!/bin/sh

case $1 in
	"status")
		MUTED=$(pacmd list-sources | awk '/\*/,EOF {print}' | awk '/muted/ {print $2; exit}')
		if [[ $MUTED = "no" ]]; then
  			echo ''
		else
  			echo ''
		fi
		;;
	"toggle")
		ID=$(pacmd list-sources | grep "*\ index:" | cut -d' ' -f5)
		pactl set-source-mute $ID toggle
		;;
esac
