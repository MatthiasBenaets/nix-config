#!/usr/bin/env sh
source "$HOME/.config/sketchybar/icons.sh"

total=0

for folder in ~/.local/share/mail/*/
do
  count=$(find "$folder"/INBOX/new/ -type f | wc -l)
  total=$((total + count))
done
echo "Total files in 'new' folders: $total"

if [ "$total" -gt "0" ]; then
  sketchybar --set $NAME label="$total" icon=$MAIL
else
  sketchybar --set $NAME label="$total" icon=$MAIL_OPEN
fi

