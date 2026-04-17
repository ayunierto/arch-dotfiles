#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"

log() { printf "\n[+] %s\n" "$1"; }
warn() { printf "\n[!] %s\n" "$1"; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    warn "Falta comando: $1"
    exit 1
  }
}

# ---- checks ----
require_cmd sudo
require_cmd git
require_cmd curl

# Detectar helper AUR
AUR_HELPER=""
if command -v yay >/dev/null 2>&1; then
  AUR_HELPER="yay"
elif command -v paru >/dev/null 2>&1; then
  AUR_HELPER="paru"
fi

# ---- paquetes base ----
log "Actualizando sistema e instalando paquetes base"

sudo pacman -Syu --noconfirm

sudo pacman -S --needed --noconfirm \
  zsh git curl unzip base-devel \
  fzf ripgrep bat ca-certificates \
  github-cli

# bat ya se llama bat en Arch, no batcat

# ---- oh-my-zsh ----
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  log "Instalando Oh My Zsh"
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "Oh My Zsh ya instalado"
fi

# ---- plugins ----
mkdir -p "${ZSH_CUSTOM_DIR}/plugins"

clone_or_update() {
  local repo="$1"
  local dest="$2"

  if [ -d "${dest}/.git" ]; then
    git -C "${dest}" pull --ff-only || true
  else
    git clone --depth=1 "${repo}" "${dest}"
  fi
}

log "Instalando plugins zsh"

clone_or_update https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM_DIR}/plugins/zsh-autosuggestions"

clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting \
  "${ZSH_CUSTOM_DIR}/plugins/zsh-syntax-highlighting"

# ---- NVM ----
if [ ! -d "${HOME}/.nvm" ]; then
  log "Instalando nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
else
  log "nvm ya instalado"
fi


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


if ! command -v node >/dev/null 2>&1; then
  log "Instalando Node LTS"
  nvm install --lts
  nvm alias default 'lts/*'
else
  log "Node ya instalado: $(node -v)"
fi

# ---- symlinks dotfiles ----
log "Creando symlinks"

link_file() {
  local src="$1"
  local dest="$2"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    warn "Backup de $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -sf "$src" "$dest"
}

# Configs
link_file "${DOTFILES_DIR}/.zshrc" "${HOME}/.zshrc"
link_file "${DOTFILES_DIR}/.aliases" "${HOME}/.aliases"
link_file "${DOTFILES_DIR}/.exports" "${HOME}/.exports"
link_file "${DOTFILES_DIR}/.gitconfig" "${HOME}/.gitconfig"

# Scripts
link_file "${DOTFILES_DIR}/bin/reload-waybar" "${HOME}/.local/bin/reload-waybar"
link_file "${DOTFILES_DIR}/bin/reload-swaync" "${HOME}/.local/bin/reload-swaync"

# ---- shell por defecto ----
if [ "${SHELL##*/}" != "zsh" ]; then
  log "Cambiando shell por defecto a zsh"
  chsh -s "$(command -v zsh)" || warn "No se pudo cambiar shell automáticamente"
fi

# ---- carpetas base para proyectos dev ----
mkdir -p "${HOME}/projects"

# ---- opcional AUR helper ----
if [ -n "${AUR_HELPER}" ]; then
  log "AUR helper detectado: ${AUR_HELPER}"
else
  warn "No se detectó yay/paru. Si usas AUR instálalo luego."
fi

log "Finalizado"
echo "Abre una nueva terminal o ejecuta: exec zsh"
