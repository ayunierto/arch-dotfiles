#!/usr/bin/env bash
set -euo pipefail

# Módulo waybar para el filtro de luz cálida hyprsunset (Hyprland).
# Lee el estado en vivo por IPC (identity get / temperature) y lo ajusta por
# pasos desde waybar. El icono se refresca al instante con SIGRTMIN+4
# (signal: 4 del módulo custom/hyprsunset).

WARM_TEMP=4500   # Kelvin al activar el filtro con el toggle
STEP=500         # pasos de la rueda del ratón (menos Kelvin = más cálido)

refresh() {
  pkill -RTMIN+4 -x waybar || true
}

status() {
  local id temp icon cls tooltip
  id=$(hyprctl hyprsunset identity get 2>/dev/null)
  temp=$(hyprctl hyprsunset temperature 2>/dev/null)

  if [[ "$id" == "false" ]]; then
    icon="󰖔"
    cls="warm"
    tooltip="Filtro cálido activo: ${temp}K\\nClic: on/off · Rueda: ±${STEP}K · Central: volver al perfil"
  elif [[ "$id" == "true" ]]; then
    icon="󰖙"
    cls="off"
    tooltip="Luz cálida apagada (${temp}K)\\nClic: on/off · Rueda: ±${STEP}K · Central: volver al perfil"
  else
    icon="󰍡"
    cls="off"
    tooltip="hyprsunset no está en ejecución"
  fi

  printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$icon" "$cls" "$tooltip"
}

toggle() {
  local id
  id=$(hyprctl hyprsunset identity get 2>/dev/null)
  if [[ "$id" == "true" ]]; then
    # temperature pone identity=false automáticamente en el daemon
    hyprctl hyprsunset temperature "$WARM_TEMP" || true
  else
    hyprctl hyprsunset identity true || true
  fi
  refresh
}

warmer() { hyprctl hyprsunset temperature -$STEP || true; refresh; }
cooler() { hyprctl hyprsunset temperature +$STEP || true; refresh; }
reset()  { hyprctl hyprsunset reset || true; refresh; }

case "${1:-}" in
  status) status ;;
  toggle) toggle ;;
  warmer) warmer ;;
  cooler) cooler ;;
  reset) reset ;;
  *) echo "Uso: $0 {status|toggle|warmer|cooler|reset}" >&2; exit 1 ;;
esac