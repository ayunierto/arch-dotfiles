# shellcheck shell=bash

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Falta comando: $1"
}

preflight_checks() {
  require_cmd sudo
  require_cmd git
  require_cmd curl
}
