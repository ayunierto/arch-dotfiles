#!/usr/bin/env bash
# shellcheck disable=SC1090
set -euo pipefail

export DOTFILES_DIR="${HOME}/.dotfiles"

source "$DOTFILES_DIR/lib/logger.sh"
source "$DOTFILES_DIR/lib/checks.sh"
source "$DOTFILES_DIR/lib/package-manager.sh"
source "$DOTFILES_DIR/lib/symlink.sh"
source "$DOTFILES_DIR/lib/systemd.sh"

main() {
  preflight_checks

  for module in "$DOTFILES_DIR"/modules/*.sh; do
    source "$module"
  done
}

main "$@"
