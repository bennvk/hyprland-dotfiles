#!/usr/bin/env bash

export PATH="$HOME/.local/bin:$PATH"

update_wallpaper() {
    awww img "$WALLPAPER" \
        --transition-type grow \
        --transition-pos 0.25,0.5 \
        --transition-duration 2 \
        --transition-fps 60 || notify-send "⚠️ Erreur WallSync ⚠️" "awww : impossible d'appliquer le fond d'écran"
}

update_kitty() {
    echo "include $HOME/.cache/wal/colors-kitty.conf" > "$HOME/.config/kitty/colors.conf"

    pkill -USR1 -x kitty
}

update_waybar() {
    if [[ -f "$HOME/.config/waybar/colors-wal.sh" ]]; then
        bash "$HOME/.config/waybar/colors-wal.sh" || notify-send "⚠️ Erreur WallSync ⚠️" "Waybar : le script de couleurs a échoué"
    else
        notify-send "⚠️ Erreur WallSync ⚠️" "Waybar : colors-wal.sh introuvable"
    fi

    pkill -x waybar
    sleep 0.3
    setsid -f waybar >/dev/null 2>&1
}

update_starship() {
    if [[ -f "$HOME/.config/starship/theme.sh" ]]; then
        bash "$HOME/.config/starship/theme.sh" || notify-send "⚠️ Erreur WallSync ⚠️" "Starship : le script a échoué"
    else
        notify-send "⚠️ Erreur WallSync ⚠️" "Starship : theme.sh introuvable"
    fi
}

update_hyprlock() {
    ext="${WALLPAPER##*.}"
    target="$HOME/.config/hyprlock/wp_hyprlock.$ext"

    rm -f "$HOME/.config"/hyprlock/wp_hyprlock.*

    if cp "$WALLPAPER" "$target"; then
        ln -sf "$target" "$HOME/.config/hyprlock/wp_hyprlock"
    else
        notify-send "⚠️ Erreur WallSync ⚠️" "Hyprlock : copie impossible"
    fi
}

update_rofi() {
    if [[ -f "$HOME/.cache/wal/colors-rofi-dark.rasi" ]]; then
        ln -sf "$HOME/.cache/wal/colors-rofi-dark.rasi" "$HOME/.config/rofi/shared/colors.rasi"
    else
        notify-send "⚠️ Erreur WallSync ⚠️" "Rofi : colors-rofi-dark.rasi introuvable"
    fi
}

update_mako() {
    if [[ ! -f "$HOME/.cache/wal/colors" ]]; then
        notify-send "⚠️ Erreur WallSync ⚠️" "Mako : fichier $HOME/.cache/wal/colors introuvable"
        return
    fi

    color1=$(sed -n '2p' "$HOME/.cache/wal/colors")
    color2=$(sed -n '3p' "$HOME/.cache/wal/colors")

    echo "border-color=$color1" > "$HOME/.config/mako/colors-mako"
    echo "background-color=$color2" >> "$HOME/.config/mako/colors-mako"

    makoctl reload
}

update_firefox() {
    if command -v pywalfox >/dev/null 2>&1; then
        timeout 5 pywalfox update || notify-send "⚠️ Erreur WallSync ⚠️" "Pywalfox : la mise à jour a échoué ou expiré"
    else
        notify-send "⚠️ Erreur WallSync ⚠️" "pywalfox non installé, étape ignorée"
    fi
}

update_sone() {
    if [[ ! -d "$HOME/.config/sone" ]]; then
        notify-send "⚠️ Erreur WallSync ⚠️" "Sone : dossier de configuration introuvable"
        return
    fi

    background=$(sed -n '1p' "$HOME/.cache/wal/colors")
    accent=$(sed -n '5p' "$HOME/.cache/wal/colors")

    cat > "$HOME/.config/sone/theme.json" <<EOF
{
  "version": 1,
  "preset": "custom",
  "custom": {
    "accent": "$accent",
    "background": "$background"
  }
}
EOF
}

WALLPAPER="$(realpath "$1" 2>/dev/null)"

if [[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]]; then
    notify-send "⚠️ Erreur WallSync ⚠️" "Fichier introuvable : $1"
    exit 1
fi

update_wallpaper

wal -i "$WALLPAPER" -n -q || {
    notify-send "⚠️ Erreur WallSync ⚠️" "pywal n'a pas pu générer la palette"
    exit 1
}

update_kitty
update_waybar
update_starship
update_hyprlock
update_rofi
update_mako
update_firefox
update_sone
