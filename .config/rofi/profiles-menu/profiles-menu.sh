#!/bin/bash

chosen=$(printf "󰍹\n󰍺" | \
  rofi -dmenu -theme ~/.config/rofi/profiles-menu/profiles-menu.rasi)

case "$chosen" in
  󰍹) 
    ln -sf ~/.config/hypr/profiles/mono/monitors-mono.lua ~/.config/hypr/modules/monitors.lua
    ln -sf ~/.config/hypr/profiles/mono/workspaces-mono.lua ~/.config/hypr/modules/workspaces.lua
    hyprctl reload
    ln -sf ~/.config/hypr/profiles/mono/waybar-mono.jsonc ~/.config/waybar/config.jsonc
    pkill waybar; nohup waybar >/dev/null 2>&1 & 
    ;;
  󰍺) 
    ln -sf ~/.config/hypr/profiles/duo/monitors-duo.lua ~/.config/hypr/modules/monitors.lua
    ln -sf ~/.config/hypr/profiles/duo/workspaces-duo.lua ~/.config/hypr/modules/workspaces.lua
    hyprctl reload
    ln -sf ~/.config/hypr/profiles/duo/waybar-duo.jsonc ~/.config/waybar/config.jsonc
    pkill waybar; nohup waybar >/dev/null 2>&1 & 
    ;;
esac
