#!/bin/bash

#
#     __    __      _ _                                                                  
#    / / /\ \ \__ _| | |_ __   __ _ _ __   ___ _ __           _ __ ___   ___ _ __  _   _ 
#    \ \/  \/ / _` | | | '_ \ / _` | '_ \ / _ \ '__|  _____  | '_ ` _ \ / _ \ '_ \| | | |
#     \  /\  / (_| | | | |_) | (_| | |_) |  __/ |    |_____| | | | | | |  __/ | | | |_| |
#      \/  \/ \__,_|_|_| .__/ \__,_| .__/ \___|_|            |_| |_| |_|\___|_| |_|\__,_|
#                      |_|         |_|                                                   
#

wallpaper_dir="$HOME/Images/Wallpapers"
preview_dir="$wallpaper_dir/preview"
theme="$HOME/.config/rofi/wallpaper-menu/wallpaper-menu.rasi"
 
mkdir -p "$preview_dir"
 
list=""
while IFS= read -r file; do
    name=$(basename "$file")
    preview="$preview_dir/${name%.*}_preview.jpg"
 
    [[ -f "$preview" ]] || magick "$file" -resize 128x72 "$preview"
 
    list+="${name}\x00icon\x1f${preview}\n"
done < <(find "$wallpaper_dir" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.webp' \) ! -path "$preview_dir/*" | sort)
 
selected_name=$(printf "$list" | rofi -dmenu -theme "$theme" -p "Choisir un fond d'écran")
 
[[ -z "$selected_name" ]] && exit 0
 
selected=$(find "$wallpaper_dir" -type f -name "$selected_name" ! -path "$preview_dir/*" | head -n 1)
 
if [[ -z "$selected" ]]; then
    notify-send "⚠️ Erreur WallSync ⚠️" "Image introuvable : $selected_name"
    exit 1
fi
 
setsid -f bash "$HOME/.config/wal/wallsync.sh" "$selected" >/dev/null 2>&1
