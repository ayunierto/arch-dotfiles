# shellcheck shell=bash

log "Sistema base"

pkg_update

pkg_install \
  zsh git curl unzip base-devel \
  fzf ripgrep bat lsd ca-certificates \
  github-cli hyprpaper hypridle swaync \
  lm_sensors noto-fonts-cjk woff2-font-awesome
