# shellcheck shell=bash
# Los apps libadwaita/GTK4 leen estas claves desde gsettings (dconf),
# no desde ~/.config/gtk-{3,4}.0/settings.ini (que es symlink del repo).

log "Tema GTK (gsettings)"

gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-blue-standard+default"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface font-name "Maple Mono NF 11"
gsettings set org.gnome.desktop.interface cursor-theme "catppuccin-mocha-blue-cursors"
gsettings set org.gnome.desktop.interface cursor-size 24