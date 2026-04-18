# shellcheck shell=bash

log() { printf "\n[+] %s\n" "$1"; }
warn() { printf "\n[!] %s\n" "$1"; }

require_cmd() {
  command -v "$1" >/dev/null || {
    warn "Falta comando: $1"
    exit 1
  }
}
