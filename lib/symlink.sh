# shellcheck shell=bash

backup_if_needed() {
  local target="$1"

  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "${target}.bak.$(date +%s)"
  fi
}

link_file() {
  local src="$1"
  local dest="$2"

  [[ -e "$src" ]] || die "No existe origen: $src"

  mkdir -p "$(dirname "$dest")"
  backup_if_needed "$dest"

  ln -sfn "$src" "$dest"
}
