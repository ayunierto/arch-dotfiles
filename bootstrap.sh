#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ayunierto/arch-dotfiles.git"
BRANCH="main"
TARGET_DIR="${HOME}/.dotfiles"

log()  { printf "\n\033[1;32m[bootstrap]\033[0m %s\n" "$1"; }
warn() { printf "\n\033[1;33m[warning]\033[0m %s\n" "$1"; }
err()  { printf "\n\033[1;31m[error]\033[0m %s\n" "$1"; }

fail() {
  err "$1"
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1
}

check_arch() {
  if ! grep -qi "arch" /etc/os-release; then
    fail "Este bootstrap fue diseñado para Arch Linux."
  fi
}

check_sudo() {
  require_cmd sudo || fail "sudo no está instalado."
}

check_net() {
  curl -Is https://github.com >/dev/null 2>&1 || \
    fail "Sin conexión a internet o GitHub inaccesible."
}

install_git() {
  if require_cmd git; then
    return
  fi

  log "Instalando git"
  sudo pacman -Syu --needed --noconfirm git
}

install_base_tools() {
  local pkgs=(curl unzip)
  local missing=()

  for pkg in "${pkgs[@]}"; do
    pacman -Qi "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
  done

  if [ "${#missing[@]}" -gt 0 ]; then
    log "Instalando dependencias: ${missing[*]}"
    sudo pacman -S --needed --noconfirm "${missing[@]}"
  fi
}

backup_existing_dir() {
  if [ -d "${TARGET_DIR}" ] && [ ! -d "${TARGET_DIR}/.git" ]; then
    local backup
    backup="${TARGET_DIR}.bak.$(date +%F-%H%M%S)"

    warn "El directorio ${TARGET_DIR} existe pero no es un repositorio git."
    warn "Moviendo a: ${backup}"

    mv "${TARGET_DIR}" "${backup}"
  fi
}

clone_repo() {
  log "Clonando dotfiles"
  git clone -b "${BRANCH}" "${REPO_URL}" "${TARGET_DIR}"
}

update_repo() {
  log "Actualizando repositorio existente"

  git -C "${TARGET_DIR}" fetch origin
  git -C "${TARGET_DIR}" pull --ff-only || \
    fail "No se pudo actualizar. Revisa cambios locales en ${TARGET_DIR}"
}

prepare_repo() {
  if [ -d "${TARGET_DIR}/.git" ]; then
    update_repo
    return
  fi

  backup_existing_dir
  clone_repo
}

run_install() {
  local install_script="${TARGET_DIR}/install.sh"

  [ -f "${install_script}" ] || \
    fail "No existe install.sh en ${TARGET_DIR}"

  log "Ejecutando install.sh"

  cd "${TARGET_DIR}"
  chmod +x "${install_script}"

  bash "${install_script}"
}

finish() {
  log "Proceso finalizado"
  echo "Abre una nueva terminal o ejecuta: exec zsh"
}

main() {
  check_arch
  check_sudo
  check_net
  install_git
  install_base_tools
  prepare_repo
  run_install
  finish
}

main "$@"
