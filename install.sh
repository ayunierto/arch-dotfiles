#!/usr/bin/env bash
# shellcheck disable=SC1090
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="${SCRIPT_DIR}"

source "$DOTFILES_DIR/lib/logger.sh"
source "$DOTFILES_DIR/lib/checks.sh"
source "$DOTFILES_DIR/lib/package-manager.sh"
source "$DOTFILES_DIR/lib/symlink.sh"

main() {
  preflight_checks

  for module in "$DOTFILES_DIR"/modules/*.sh; do
    source "$module"
  done
}

main "$@"
