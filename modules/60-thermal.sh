# shellcheck shell=bash

log "Thermal Guard"

sudo tee /etc/sudoers.d/90-ryzenadj >/dev/null <<EOF
$USER ALL=(ALL) NOPASSWD: /usr/bin/ryzenadj
EOF

sudo chmod 440 /etc/sudoers.d/90-ryzenadj
sudo visudo -cf /etc/sudoers.d/90-ryzenadj

mkdir -p "$HOME/.config/systemd/user"

link_file \
"$DOTFILES_DIR/systemd/thermal-guard.service" \
"$HOME/.config/systemd/user/thermal-guard.service"

user_service_enable thermal-guard.service
