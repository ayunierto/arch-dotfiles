#!/usr/bin/env bash
set -euo pipefail

TZ_LOCAL="America/Lima"

# La evaluación se hace en UTC. Para evitar subshells y el comando externo 'date'
# (que en next_change se llamaría decenas de veces), se calcula día y hora con
# operaciones aritméticas sobre el epoch: epoch 0 (1 Ene 1970) fue jueves.
is_peak() {
  local epoch=$1 days dow hour

  days=$(( epoch / 86400 ))
  dow=$(( (days + 3) % 7 + 1 ))
  hour=$(( (epoch % 86400) / 3600 ))

  # Peak solo de lunes (1) a viernes (5), en horarios UTC definidos aquí
  [[ "$dow" -ge 1 && "$dow" -le 5 ]] || return 1
  { (( hour >= 1 && hour < 4 )) || (( hour >= 6 && hour < 10 )); }
}

next_change() {
  local epoch=$1 state top t t_state i

  if is_peak "$epoch"; then state=peak; else state=offpeak; fi
  top=$(( epoch / 3600 * 3600 ))
  for (( i = 1; i <= 72; i++ )); do
    t=$(( top + i * 3600 ))
    if is_peak "$t"; then t_state=peak; else t_state=offpeak; fi
    if [[ "$t_state" != "$state" ]]; then
      echo "$t"
      return
    fi
  done
  echo "$(( top + 72 * 3600 ))"
}

fmt_duration() {
  local secs=$1 h m
  h=$(( secs / 3600 ))
  m=$(( (secs % 3600) / 60 ))
  printf "%dh %02dmin\n" "$h" "$m"
}

status() {
  local now next diff next_fmt dur icon cls state label tooltip
  now=$(date +%s)
  next=$(next_change "$now")
  diff=$(( next - now ))

  if is_peak "$now"; then
    state="PEAK"
    cls="peak"
    icon="󰁔"
    label="tarifa completa"
  else
    state="OFF-PEAK"
    cls="offpeak"
    icon="󰁅"
    label="50% de descuento"
  fi

  next_fmt=$(TZ="$TZ_LOCAL" date -d "@$next" '+%a %H:%M')
  dur=$(fmt_duration "$diff")

  tooltip="DeepSeek: $state ($label)\\nCambio: $next_fmt hora local (en $dur)\\nPeak local: Dom 20-23h, Lun-Jue 01-05h y 20-23h, Vie 01-05h. El resto: 50% off."

  printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$icon" "$cls" "$tooltip"
}

watch() {
  local prev="" now state next next_fmt dur

  command -v notify-send >/dev/null || { echo "Error: notify-send no está instalado." >&2; exit 1; }

  while true; do
    now=$(date +%s)
    if is_peak "$now"; then state=peak; else state=offpeak; fi

    if [[ -n "$prev" && "$state" != "$prev" ]]; then
      next=$(next_change "$now")
      next_fmt=$(TZ="$TZ_LOCAL" date -d "@$next" '+%a %H:%M')
      dur=$(fmt_duration "$(( next - now ))")

      if [[ "$state" == "peak" ]]; then
        notify-send -a "DeepSeek" -u normal -i "weather-clear-night" "DeepSeek: tarifa completa" \
          "Horario peak hasta ~$next_fmt (en $dur). Descuento 50% desactivado." || true
      else
        notify-send -a "DeepSeek" -u normal -i "weather-clear" "DeepSeek: 50% de descuento" \
          "Horario off-peak hasta ~$next_fmt (en $dur). Buen momento para darle uso o el modelo pro." || true
      fi

      # Refrescar el icono de waybar al instante (SIGRTMIN+3 del módulo custom/deepseek)
      pkill -RTMIN+3 -x waybar || true
    fi

    prev=$state
    # Sincronizar el chequeo al inicio del siguiente minuto para no arrastrar deriva
    sleep $(( 60 - $(date +%S) ))
  done
}

case "${1:-}" in
  status) status ;;
  watch) watch ;;
  *) echo "Uso: $0 {status|watch}" >&2; exit 1 ;;
esac