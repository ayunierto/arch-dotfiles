#!/usr/bin/env bash
set -euo pipefail

TZ_PERU="America/Lima"

is_peak() {
  local epoch=$1 dow hour
  dow=$(date -u -d "@$epoch" +%u)
  hour=$(date -u -d "@$epoch" +%H)
  hour=$(( 10#$hour ))
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
  printf "%dh %02dmin" "$h" "$m"
}

status() {
  local now next diff next_fmt today_fmt dur icon cls state label
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

  next_fmt=$(TZ="$TZ_PERU" date -d "@$next" '+%a %H:%M')
  dur=$(fmt_duration "$diff")

  printf '{"text":"%s","class":"%s","tooltip":"%s\\n%s\\n%s"}' \
    "$icon" "$cls" \
    "DeepSeek: $state ($label)" \
    "Cambio: $next_fmt hora local (en $dur)" \
    "Peak local: Dom 20-23h, Lun-Jue 01-05h y 20-23h, Vie 01-05h. El resto: 50% off."
}

watch() {
  local prev="" now state next next_fmt dur
  while true; do
    now=$(date +%s)
    if is_peak "$now"; then state=peak; else state=offpeak; fi

    if [[ -n "$prev" && "$state" != "$prev" ]]; then
      next=$(next_change "$now")
      next_fmt=$(TZ="$TZ_PERU" date -d "@$next" '+%a %H:%M')
      dur=$(fmt_duration "$(( next - now ))")
      if [[ "$state" == "peak" ]]; then
        notify-send -u normal "DeepSeek: tarifa completa" \
          "Horario peak hasta ~$next_fmt (en $dur). Descuento 50% desactivado." || true
      else
        notify-send -u normal "DeepSeek: 50% de descuento" \
          "Horario off-peak hasta ~$next_fmt (en $dur). Buen momento para darle uso o el modelo pro." || true
      fi
    fi

    prev=$state
    sleep 60
  done
}

case "${1:-}" in
  status) status ;;
  watch) watch ;;
  *) echo "Uso: $0 {status|watch}" >&2; exit 1 ;;
esac