#!/usr/bin/env bash

trap 'pkill -P $$' EXIT

command -v nmcli >/dev/null || exit 0

nm() { LC_ALL=C nmcli "$@"; }

notify() {
  local args=(-a network -e -h string:x-canonical-private-synchronous:network)
  [[ -n $2 ]] && args+=(-i "$2")
  [[ -n ${3:-} ]] && args+=(-c "$3")
  notify-send "${args[@]}" "$1"
}

wifi_ssid() {
  local ssid
  ssid=$(nm -t -f ACTIVE,SSID device wifi 2>/dev/null | sed -n 's/^yes://p' | head -n1 | sed 's/\\:/:/g')
  [[ -n $ssid ]] || ssid=$(nm -t -f TYPE,STATE,CONNECTION device 2>/dev/null |
    awk -F: '$1=="wifi" && $2 ~ /^connected/ {print $3; exit}')
  echo "$ssid"
}

net_state() {
  local devs
  devs=$(nm -t -f TYPE,STATE device 2>/dev/null)
  if grep -q '^ethernet:connected' <<<"$devs"; then
    echo "ethernet"
  elif grep -q '^wifi:connected' <<<"$devs"; then
    echo "wifi:$(wifi_ssid)"
  fi
}

last=$(net_state)

LC_ALL=C nmcli monitor | while read -r _; do
  sleep 1
  while read -r -t 0.2 _; do :; done

  now=$(net_state)
  [[ $now == "$last" ]] && continue

  if [[ -z $now ]]; then
    sleep 3
    now=$(net_state)
    [[ $now == "$last" ]] && continue
  fi

  case $now in
    ethernet) notify "Connecté via Ethernet" "$HOME/.config/mako/icons/network-ethernet.png" ;;
    wifi:*)   notify "Connecté au réseau ${now#wifi:}" "$HOME/.config/mako/icons/network-wifi.png" ;;
    *)        notify "Aucun réseau connecté" "$HOME/.config/mako/icons/network-offline.png" offline ;;
  esac
  last=$now
done
