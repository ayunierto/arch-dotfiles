#!/usr/bin/env bash
# Instalador opcional de Thermal Guard (perfil personal para AMD Ryzen).
# No forma parte de install.sh: se ejecuta a mano cuando se quiera usar.
set -euo pipefail

EXTRAS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$EXTRAS_DIR/../.." && pwd)"

source "$DOTFILES_DIR/lib/logger.sh"
source "$DOTFILES_DIR/lib/checks.sh"
source "$DOTFILES_DIR/lib/package-manager.sh"
source "$DOTFILES_DIR/lib/symlink.sh"
source "$DOTFILES_DIR/lib/systemd.sh"

preflight() {
  grep -qi "arch" /etc/os-release || die "Thermal Guard está pensado para Arch Linux."
  require_cmd sudo
  require_cmd git
}

install_deps() {
  if ! command -v sensors >/dev/null 2>&1; then
    log "Instalando lm_sensors"
    pkg_install lm_sensors
  fi

  if ! command -v ryzenadj >/dev/null 2>&1; then
    log "Instalando ryzenadj (AUR)"
    aur_install ryzenadj
  fi
}

install_sudoers() {
  local bin
  bin="$(command -v ryzenadj)"

  log "Configurando sudoers para ryzenadj ($bin)"

  sudo tee /etc/sudoers.d/90-ryzenadj >/dev/null <<EOF
$USER ALL=(ALL) NOPASSWD: $bin
EOF

  sudo chmod 440 /etc/sudoers.d/90-ryzenadj
  sudo visudo -cf /etc/sudoers.d/90-ryzenadj
}

install_service() {
  mkdir -p "$HOME/.local/bin" "$HOME/.config/systemd/user"

  link_file "$EXTRAS_DIR/thermal-guard.sh" "$HOME/.local/bin/thermal-guard.sh"
  link_file "$EXTRAS_DIR/thermal-guard.service" "$HOME/.config/systemd/user/thermal-guard.service"

  chmod +x "$HOME/.local/bin/thermal-guard.sh"

  user_service_enable thermal-guard.service
}

main() {
  preflight
  install_deps
  install_sudoers
  install_service
  log "Thermal Guard instalado"
}

main "$@"
