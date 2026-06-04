# shellcheck shell=bash

log "Sistema base"

pkg_update

pkg_install \
  zsh git curl unzip base-devel \
  fzf ripgrep bat lsd ca-certificates \
  github-cli hyprpaper hypridle hyprlock \
  swaync lm_sensors fish \
  noto-fonts-cjk woff2-font-awesome
