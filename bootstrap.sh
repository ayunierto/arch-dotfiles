1#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ayunierto/arch-dotfiles.git"
TARGET_DIR="${HOME}/.dotfiles"

log()  { printf "\n\033[1;32m[bootstrap]\033[0m %s\n" "$1"; }
warn() { printf "\n\033[1;33m[warning]\033[0m %s\n" "$1"; }
err()  { printf "\n\033[1;31m[error]\033[0m %s\n" "$1"; }

# ---- validar Arch Linux ----
if ! grep -qi "arch" /etc/os-release; then
  err "Este bootstrap fue adaptado para Arch Linux."
  exit 1
fi

# ---- prerequisitos ----
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || return 1
}

# ---- conexión ----
check_net() {
  ping -c1 github.com >/dev/null 2>&1 || {
    err "Sin conexión a internet."
    exit 1
  }
}

check_net

# ---- instalar git si falta ----
if ! require_cmd git; then
  log "Instalando git"
  sudo pacman -Sy --noconfirm git
fi

# ---- herramientas recomendadas ----
PKGS=(curl unzip)

MISSING=()
for pkg in "${PKGS[@]}"; do
  pacman -Qi "$pkg" >/dev/null 2>&1 || MISSING+=("$pkg")
done

if [ ${#MISSING[@]} -gt 0 ]; then
  log "Instalando dependencias: ${MISSING[*]}"
  sudo pacman -S --needed --noconfirm "${MISSING[@]}"
fi

# ---- clonar o actualizar repo ----
if [ -d "${TARGET_DIR}/.git" ]; then
  log "Actualizando repo existente"

  git -C "${TARGET_DIR}" fetch origin
  git -C "${TARGET_DIR}" pull --ff-only

elif [ -d "${TARGET_DIR}" ]; then
  BACKUP="${TARGET_DIR}.bak.$(date +%F-%H%M%S)"
  warn "El directorio existe pero no es git. Backup -> ${BACKUP}"
  mv "${TARGET_DIR}" "${BACKUP}"

  log "Clonando dotfiles"
  git clone "${REPO_URL}" "${TARGET_DIR}"

else
  log "Clonando dotfiles"
  git clone "${REPO_URL}" "${TARGET_DIR}"
fi

# ---- ejecutar install.sh ----
INSTALL_SCRIPT="${TARGET_DIR}/install.sh"

if [ ! -f "${INSTALL_SCRIPT}" ]; then
  err "No existe install.sh en ${TARGET_DIR}"
  exit 1
fi

log "Ejecutando install.sh"

cd "${TARGET_DIR}"
chmod +x "${INSTALL_SCRIPT}"
./install.sh

log "Proceso finalizado"
echo "Abre una nueva terminal o ejecuta: exec zsh"
