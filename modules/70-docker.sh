# shellcheck shell=bash

log "Docker"

pkg_install docker docker-compose

sudo systemctl enable docker || true
sudo systemctl start docker || true
sudo usermod -aG docker "$USER" || true
