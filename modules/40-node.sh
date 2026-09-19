# shellcheck shell=bash

log "Configurando Node"

if [[ -s "$HOME/.config/nvm/nvm.sh" ]]; then
  export NVM_DIR="$HOME/.config/nvm"
elif [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  export NVM_DIR="$HOME/.nvm"
else
  export NVM_DIR="$HOME/.config/nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | PROFILE=/dev/null bash
fi

# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

if ! command -v node >/dev/null 2>&1; then
  nvm install --lts
  nvm alias default 'lts/*'
fi

corepack enable || true
