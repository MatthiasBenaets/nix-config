#!/bin/sh

ID1=$(awk '/ 44./ {sub(/.$/,"",$2); print $2 }' <(wpctl status))
ID2=$(awk '/ S10 Bluetooth Speaker/ {sub(/.$/,"",$2); print $2 }' <(wpctl status) | sed -n 2p)

HEAD=$(awk '/ 44./ { print $2 }' <(wpctl status | grep "*"))
SPEAK=$(awk '/ S10 Bluetooth Speaker/ { print $2 }' <(wpctl status | grep "*"))

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
