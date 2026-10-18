#!/usr/bin/env bash

set -u

ACTION="${1:-}"
BACKEND="${2:-auto}"
DDC_SN="${3:-}"

DDC_STEP=25
BC_STEP_DIVIDER=20

MON_NAME="" MON_SERIAL="" LABEL=""

[[ $ACTION == up || $ACTION == down ]] || usage

fail() {
  notify-send -a brightness "Luminosité" "$1"
  exit 1
}

resolve_target() {
  local cx cy mons line
  IFS=', ' read -r cx cy <<<"$(hyprctl cursorpos 2>/dev/null)"
  cx=${cx%.*}; cy=${cy%.*}
  [[ $cx =~ ^-?[0-9]+$ && $cy =~ ^-?[0-9]+$ ]] || { cx=-1; cy=-1; }

  mons=$(hyprctl monitors -j 2>/dev/null) || return 1

  line=$(jq -r --argjson x "$cx" --argjson y "$cy" '
    .[]
    | (if (.transform % 2) == 1 then [.height, .width] else [.width, .height] end) as [$w, $h]
    | select($x >= .x and $x < .x + ($w / .scale) and $y >= .y and $y < .y + ($h / .scale))
    | [.name, .serial] | @tsv' <<<"$mons" | head -n1)

  [[ -n $line ]] || line=$(jq -r '.[] | select(.focused) | [.name, .serial] | @tsv' <<<"$mons" | head -n1)

  IFS=$'\t' read -r MON_NAME MON_SERIAL <<<"$line"
  [[ -n $MON_NAME ]]
}

DDC_SEL=()
resolve_ddc_selector() {
  local link bus
  if [[ -n $MON_NAME && -z $DDC_SN ]]; then
    for link in /sys/class/drm/card*-"$MON_NAME"/ddc; do
      [[ -e $link ]] || continue
      bus=$(basename "$(readlink -f "$link")"); bus=${bus#i2c-}
      if [[ $bus =~ ^[0-9]+$ ]]; then DDC_SEL=(--bus "$bus"); return 0; fi
    done
  fi
  local sn=${DDC_SN:-$MON_SERIAL}
  [[ -n $sn ]] && { DDC_SEL=(--sn "$sn"); return 0; }
  return 1
}

compute_new() {
  local current=$1 step=$2 min=$3 max=$4 new
  ((step < 1)) && step=1
  if [[ $ACTION == up ]]; then new=$((current + step)); else new=$((current - step)); fi
  ((new < min)) && new=$min
  ((new > max)) && new=$max
  echo "$new"
}

notify() {
  local percent=$1 level=max
  if   ((percent == 0));  then level=zero
  elif ((percent <= 25)); then level=low
  elif ((percent <= 50)); then level=medium
  elif ((percent <= 75)); then level=high
  fi

  notify-send -a osd-panel -e \
    -i "$HOME/.config/mako/icons/brightness-$level.png" \
    -h string:x-canonical-private-synchronous:osd-brightness \
    -h "int:value:$percent" "${percent}%"
}

if [[ $BACKEND == auto ]]; then
  resolve_target || fail "Impossible de déterminer l'écran pointé (hyprctl / jq ?)"
  case $MON_NAME in
    eDP*|LVDS*|DSI*) BACKEND=brightnessctl; LABEL="Portable" ;;
    *)               BACKEND=ddcutil;       LABEL="$MON_NAME" ;;
  esac
fi

case $BACKEND in
  brightnessctl)
    LABEL=${LABEL:-Portable}
    MAX=$(brightnessctl m) || fail "brightnessctl indisponible"
    CURRENT=$(brightnessctl g)
    NEW=$(compute_new "$CURRENT" $((MAX / BC_STEP_DIVIDER)) 0 "$MAX")

    brightnessctl -q set "$NEW"
    notify $(((NEW * 100 + MAX / 2) / MAX))
    ;;

  ddcutil)
    LABEL=${LABEL:-Écran ${DDC_SN:-externe}}
    resolve_ddc_selector || fail "Écran $LABEL : ni bus I2C ni numéro de série trouvés"
    DDC=(ddcutil --noverify "${DDC_SEL[@]}")

    cache_dir="${XDG_RUNTIME_DIR:-/tmp}/brightness"
    mkdir -p "$cache_dir"
    cache="$cache_dir/ddc-${MON_NAME:-${DDC_SN:-default}}"
    exec 9>"$cache.lock"
    flock 9

    if [[ -f $cache ]] && (($(date +%s) - $(stat -c %Y "$cache") < 30)); then
      read -r CURRENT MAX <"$cache"
    else
      raw=$("${DDC[@]}" getvcp 10 --terse 2>/dev/null)
      read -r _ _ _ CURRENT MAX <<<"$raw"
    fi
    [[ ${CURRENT:-} =~ ^[0-9]+$ && ${MAX:-} =~ ^[0-9]+$ && $MAX -gt 0 ]] ||
      fail "Impossible de lire la luminosité de $LABEL"

    NEW=$(compute_new "$CURRENT" $((MAX * DDC_STEP / 100)) 0 "$MAX")
    if ((NEW != CURRENT)); then
      "${DDC[@]}" setvcp 10 "$NEW" || fail "Échec du réglage sur $LABEL"
    fi
    echo "$NEW $MAX" >"$cache"

    notify $(((NEW * 100 + MAX / 2) / MAX))
    ;;

  *) usage ;;
esac
