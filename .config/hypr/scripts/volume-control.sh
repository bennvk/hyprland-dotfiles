#!/usr/bin/env bash

set -u

STEP=5
SINK='@DEFAULT_AUDIO_SINK@'

case "${1:-}" in
  up)   wpctl set-volume -l 1.5 "$SINK" "${STEP}%+" ;;
  down) wpctl set-volume "$SINK" "${STEP}%-" ;;
  mute) wpctl set-mute "$SINK" toggle ;;
  *) echo "usage: ${0##*/} up|down|mute" >&2; exit 1 ;;
esac

out=$(wpctl get-volume "$SINK")
v=$(awk '{printf "%d", $2*100+0.5}' <<<"$out")

if [[ $out == *MUTED* ]]; then
  level=mute; text="Muet"; bar=0
else
  level=gain
  ((v <= 100)) && level=high
  ((v <= 66))  && level=medium
  ((v <= 33))  && level=low
  text="${v}%"
  bar=$((v > 100 ? 100 : v))
fi

notify-send -a osd-panel -e \
  -i "$HOME/.config/mako/icons/volume-$level.png" \
  -h string:x-canonical-private-synchronous:osd-volume \
  -h "int:value:$bar" "$text"
