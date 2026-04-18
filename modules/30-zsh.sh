# shellcheck shell=bash

log "Configurando Zsh"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

clone_or_update() {
  local repo="$1"
  local dest="$2"

  if [[ -d "$dest/.git" ]]; then
    git -C "$dest" pull --ff-only || true
  else
    git clone --depth=1 "$repo" "$dest"
  fi
}

clone_or_update \
https://github.com/zsh-users/zsh-autosuggestions \
"$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_or_update \
https://github.com/zsh-users/zsh-syntax-highlighting \
"$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

if [[ "${SHELL##*/}" != "zsh" ]]; then
  chsh -s "$(command -v zsh)" || true
fi
