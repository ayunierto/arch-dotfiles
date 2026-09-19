# shellcheck shell=bash

log "Thermal Guard"

RYZENADJ_BIN="$(command -v ryzenadj || true)"

if [[ -z "$RYZENADJ_BIN" ]]; then
  warn "ryzenadj no encontrado; se omite Thermal Guard"
  return 0
fi

sudo tee /etc/sudoers.d/90-ryzenadj >/dev/null <<EOF
$USER ALL=(ALL) NOPASSWD: $RYZENADJ_BIN
EOF

sudo chmod 440 /etc/sudoers.d/90-ryzenadj
sudo visudo -cf /etc/sudoers.d/90-ryzenadj

mkdir -p "$HOME/.config/systemd/user"

link_file \
"$DOTFILES_DIR/systemd/thermal-guard.service" \
"$HOME/.config/systemd/user/thermal-guard.service"

user_service_enable thermal-guard.service
