#!/bin/bash

set -euo pipefail

scriptpwd="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Création des répertoires personnels ==="

mkdir -p "$HOME/Documents"
mkdir -p "$HOME/Downloads"
mkdir -p "$HOME/Github"
mkdir -p "$HOME/Images/Screenshots"
mkdir -p "$HOME/Images/Wallpapers"

read -rp "Installer les paquets Nvidia / Gaming (nvidia, vulkan, gamemode...) ? (o/n) : " rep_nvidia

echo "=== Installation des paquets pacman ==="

pacman_pkgs=(
  hyprland awww firefox rofi
  kitty zsh zsh-completions
  hyprlock papirus-icon-theme
  starship fastfetchu disks2
  neovim mako yazi resvg galculator
  grim slurp wl-clipboard cliphist
  brightnessctl ddcutil swayimg 7zip
  cpupower pavucontrol ufw jq 
  inter-font ttf-cascadia-code
  ttf-nerd-fonts-symbols python-pywal
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
)

if [[ "$rep_nvidia" == "o" || "$rep_nvidia" == "O" ]]; then
  pacman_pkgs+=(
    nvidia-utils nvidia-settings
    lib32-nvidia-utils vulkan-tools
    vulkan-icd-loader lib32-vulkan-icd-loader
    gamemode lib32-gamemode
  )
fi

sudo pacman -S "${pacman_pkgs[@]}"

echo "=== Installation des paquets AUR ==="

yay_pkgs=(
  waybar-git
  python-pywalfox
  dracula-gtk-theme
  vscodium-bin
  bibata-cursor-theme-bin
)

if [[ "$rep_nvidia" == "o" || "$rep_nvidia" == "O" ]]; then
  yay_pkgs+=(proton-ge-custom-bin)
fi

yay -S "${yay_pkgs[@]}"

echo "=== Copie des fichiers de configurations ==="

configs=(
  fastfetch fontconfig hypr
  hyprlock kitty mako nvim
  rofi starship VSCodium wal
  waybar yazi
)

for cfg in "${configs[@]}"; do
  mkdir -p "$HOME/.config/$cfg"
  cp -R "$scriptpwd/.config/$cfg/." "$HOME/.config/$cfg/"
done

find "$HOME/.config/hypr" -type f -name "*.sh" -exec chmod +x {} \;


read -rp "Importer les fonds d'écran ? (o/n) : " rep

if [[ "$rep" == "o" || "$rep" == "O" ]]; then
  echo "=== Importation des fonds d'écran ==="
  cp -R "$scriptpwd/Images/Wallpapers/." "$HOME/Images/Wallpapers"
fi


echo "=== Configuration de Zsh ==="

if command -v zsh &>/dev/null; then
  chsh -s "$(command -v zsh)" "$USER"
fi

cp "$scriptpwd/.zshrc" "$HOME/.zshrc"
cp "$scriptpwd/.zprofile" "$HOME/.zprofile"

echo "=== Activation du service udisks2 ==="

sudo systemctl start udisks2
sudo systemctl enable udisks2

echo "=== Configuration de yazi ==="

if command -v ya &>/dev/null; then
    ya pkg install
else
    echo "'ya' introuvable, plugins Yazi non installés."
fi

echo "=== Installation de la session Hyprland terminée ==="
