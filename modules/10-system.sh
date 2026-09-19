# shellcheck shell=bash

log "Sistema base"

pkg_update

pkg_install \
  zsh git curl unzip base-devel \
  fzf ripgrep bat lsd ca-certificates libnotify \
  github-cli hyprpaper hypridle hyprlock \
  waybar swaync wofi rofi kitty \
  grim slurp brightnessctl playerctl wmctrl \
  wireplumber pavucontrol \
  network-manager-applet blueman \
  nwg-look papirus-icon-theme gnome-themes-extra \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk polkit-gnome \
  dolphin chromium zed \
  lm_sensors fish \
  noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd \
  adwaita-fonts
