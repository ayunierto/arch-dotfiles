# shellcheck shell=bash

pkg_update() {
  sudo pacman -Syu --noconfirm
}

pkg_install() {
  sudo pacman -S --needed --noconfirm "$@"
}

aur_detect() {
  command -v yay >/dev/null 2>&1 && { echo yay; return; }
  command -v paru >/dev/null 2>&1 && { echo paru; return; }
  echo ""
}

aur_bootstrap() {
  local tmp
  tmp=$(mktemp -d)

  git clone https://aur.archlinux.org/yay.git "$tmp/yay"

  (
      cd "$tmp/yay" || die "No se pudo entrar a $tmp/yay"
    makepkg -si --noconfirm
  )

  rm -rf "$tmp"
}

aur_install() {
  local helper
  helper=$(aur_detect)

  if [[ -z "$helper" ]]; then
    log "Instalando yay"
    aur_bootstrap
    helper="yay"
  fi

  "$helper" -S --needed --noconfirm \
    --answerclean None \
    --answerdiff None \
    --removemake \
    "$@"
}
