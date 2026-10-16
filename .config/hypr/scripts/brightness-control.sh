#!/bin/bash

ACTION="$1"
BACKEND="$2"
DDC_SN="$3"

DDC_STEP=25          # pas en % pour ddcutil
BC_STEP_DIVIDER=20   # brightnessctl : pas = max / 20 (soit 5 %)
ICON_DIR="$HOME/.config/mako/icons"

usage() {
    echo "Usage : $0 up|down brightnessctl|ddcutil [display]" >&2
    exit 1
}

[[ "$ACTION" == "up" || "$ACTION" == "down" ]] || usage

compute_new() {
    local current=$1 step=$2 max=$3 new
    if [[ "$ACTION" == "up" ]]; then
        new=$(( current + step ))
    else
        new=$(( current - step ))
    fi
    (( new < 0 )) && new=0
    (( new > max )) && new=$max
    echo "$new"
}

notify() {
    local percent=$1 icon
    if   (( percent == 0 ));  then icon="$ICON_DIR/brightness-zero.png"
    elif (( percent <= 25 )); then icon="$ICON_DIR/brightness-low.png"
    elif (( percent <= 50 )); then icon="$ICON_DIR/brightness-medium.png"
    elif (( percent <= 75 )); then icon="$ICON_DIR/brightness-high.png"
    else                           icon="$ICON_DIR/brightness-max.png"
    fi

    notify-send -i "$icon" "${percent}%" \
        -a osd-panel \
        -e -h string:x-canonical-private-synchronous:osd
}

case "$BACKEND" in
    brightnessctl)
        MAX=$(brightnessctl m)
        CURRENT=$(brightnessctl g)
        NEW=$(compute_new "$CURRENT" $(( MAX / BC_STEP_DIVIDER )) "$MAX")

        brightnessctl -q set "$NEW"
        notify $(( NEW * 100 / MAX ))
        ;;

    ddcutil)
        DDC_ARGS=()
        [[ -n "$DDC_SN" ]] && DDC_ARGS=(--sn "$DDC_SN")

        RAW=$(/usr/bin/ddcutil "${DDC_ARGS[@]}" getvcp 10)
        CURRENT=$(echo "$RAW" | grep -oP 'current value\s*=\s*\K[0-9]+')

        if ! [[ "$CURRENT" =~ ^[0-9]+$ ]]; then
            notify-send -a osd-panel "Luminosité" "Impossible de lire la luminosité de l'écran externe"
            exit 1
        fi

        NEW=$(compute_new "$CURRENT" "$DDC_STEP" 100)

        /usr/bin/ddcutil "${DDC_ARGS[@]}" setvcp 10 "$NEW"
        notify "$NEW"
        ;;

    *)
        usage
        ;;
esac
