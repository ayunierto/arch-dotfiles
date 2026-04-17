#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"
BIN_SRC="$DOTFILES_DIR/bin"
CONFIG_SRC="$DOTFILES_DIR/config"
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
  fzf ripgrep bat lsd ca-certificates \
  github-cli hyprpaper

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
log "*************************"
log "** Creando symlinks... **"
log "*************************"

# If exist make backup
backup() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local ts
    ts=$(date +%Y%m%d_%H%M%S)
    mv "$target" "${target}.backup.${ts}"
    echo "Backup creado: ${target}.backup.${ts}"
  fi
}

# Create symlinks
link_file() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    echo "⚠️  No existe origen: $src" >&2
    return 1
  fi

  mkdir -p "$(dirname "$dest")"
  backup "$dest"

  ln -sf "$src" "$dest"
  echo "✓ $dest -> $src"
}

# Archivos en la raíz del home (~)
FILES=(
  ".zshrc"
  ".aliases"
  ".exports"
  ".gitconfig"
)

# Directorios dentro de ~/.config
CONFIG_DIRS=(
  "hypr"
  "kitty"
  "rofi"
  "swaync"
  "waybar"
  "wofi"
)

# Archivos dentro de ~/.local/bin
BIN_FILES=(
    "reload-swaync"
    "reload-waybar"
)

# Archivos en $HOME
for f in "${FILES[@]}"; do
    link_file "$DOTFILES_DIR/$f" "$HOME/$f"
done

 # Scripts en ~/.local/bin
 mkdir -p "$HOME/.local/bin"
 for b in "${BIN_FILES[@]}"; do
   link_file "$BIN_SRC/$b" "$HOME/.local/bin/$b"
 done

# Directorios en ~/.config
for d in "${CONFIG_DIRS[@]}"; do
  link_file "$CONFIG_SRC/$d" "$HOME/.config/$d"
done

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

  # Instalación de fuentes
  if [ "${AUR_HELPER}" == "yay" ]; then
      yay -Sy maplemono-nf-unhinted ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono \
              ttf-nerd-fonts-symbols-common ttf-font-awesome noto-fonts-cjk ttf-ms-win11-auto

    fc-cache -fv
  fi
else
    warn "No se detectó yay/paru. Si usas AUR instálalo luego."
    warn "Instala las fuentes necesarias para que los iconos se muestren correctamente."
fi

log "Finalizado"
echo "Abre una nueva terminal o ejecuta: exec zsh"
