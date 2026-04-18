# shellcheck shell=bash

user_service_enable() {
  local service="$1"

  systemctl --user daemon-reload || true
  systemctl --user enable "$service" || true
  systemctl --user restart "$service" || true
}
