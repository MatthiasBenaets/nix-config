#!/usr/bin/env sh
source "$HOME/.config/sketchybar/icons.sh"

profile="$HOME/Library/Thunderbird/Profiles/5wpj8jv2.default-release"
regex='\(\^A1=([0-9]+)'

count_unreadmails() {
    count=0
    result=$(grep -Eo "$regex" "$1" | tail -n1)
    # result=$(grep -Eo "$regex" "$1")
    if [[ $result =~ $regex ]]
    then
        count="${BASH_REMATCH[1]}"
        unreadmail_count=$(($unreadmail_count + $count))
    fi
    return $count
}

unreadmail_count=0

for inbox in "$profile/Mail/smart mailboxes/Inbox.msf"
do
    count_unreadmails "$inbox"
done

COUNT=$unreadmail_count

if [ "$COUNT" -gt "0" ]; then
  sketchybar --set $NAME label="$COUNT" icon=$MAIL
else
  sketchybar --set $NAME label="$COUNT" icon=$MAIL_OPEN
fi
