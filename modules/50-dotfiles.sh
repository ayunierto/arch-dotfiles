# shellcheck shell=bash

log "Symlinks"

link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.aliases" "$HOME/.aliases"
link_file "$DOTFILES_DIR/.exports" "$HOME/.exports"
link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

link_file "$DOTFILES_DIR/config/gtk/gtk-3.0" "$HOME/.config/gtk-3.0"
link_file "$DOTFILES_DIR/config/gtk/gtk-4.0" "$HOME/.config/gtk-4.0"
link_file "$DOTFILES_DIR/config/hypr" "$HOME/.config/hypr"
link_file "$DOTFILES_DIR/config/kitty" "$HOME/.config/kitty"
link_file "$DOTFILES_DIR/config/swaync" "$HOME/.config/swaync"
link_file "$DOTFILES_DIR/config/swayosd" "$HOME/.config/swayosd"
link_file "$DOTFILES_DIR/config/waybar" "$HOME/.config/waybar"
link_file "$DOTFILES_DIR/config/wofi" "$HOME/.config/wofi"

mkdir -p "$HOME/.local/bin"

link_file "$DOTFILES_DIR/bin/reload-swaync" "$HOME/.local/bin/reload-swaync"
link_file "$DOTFILES_DIR/bin/reload-waybar" "$HOME/.local/bin/reload-waybar"

chmod +x \
  "$HOME/.local/bin/reload-swaync" \
  "$HOME/.local/bin/reload-waybar"
