#!/bin/sh

ID1=$(awk '/ Built-in Audio Analog Stereo/ {sub(/.$/,"",$2); print $2 }' <(wpctl status) | head -n 1)
ID2=$(awk '/ S10 Bluetooth Speaker/ {sub(/.$/,"",$2); print $2 }' <(wpctl status) | sed -n 2p)

HEAD=$(awk '/ Built-in Audio Analog Stereo/ { print $2 }' <(wpctl status | grep "*") | sed -n 2p)
SPEAK=$(awk '/ S10 Bluetooth Speaker/ { print $2 }' <(wpctl status | grep "*") | head -n 1)

case $1 in
	"status")
		if [[ $HEAD = "*" ]]; then
			echo ''
		elif [[ $SPEAK = "*" ]]; then
			echo '蓼'
		fi
	;;
	"toggle")
		if [[ $HEAD = "*" ]]; then
			wpctl set-default $ID2
		elif [[ $SPEAK = "*" ]]; then
			wpctl set-default $ID1
		fi
	;;
esac
