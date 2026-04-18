#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
# THERMAL GUARD PRO - Ryzen Laptop / Arch Linux
# Optimizado para ASUS VivoBook Ryzen 7
# Compatible con systemd
# ==========================================================

# ---------------- CONFIG ----------------
readonly TEMP_CRITICAL=80        # Cambia a modo conservador si supera esto
readonly TEMP_SAFE=65            # Regresa a turbo si baja de esto
readonly HOT_TIME_LIMIT=30       # Segundos calientes sostenidos
readonly COOL_TIME_LIMIT=20      # Segundos fríos sostenidos
readonly CHECK_INTERVAL=5        # Intervalo entre chequeos

readonly MODE_TURBO="TURBO"
readonly MODE_CONSERVATIVE="CONSERVATIVE"

readonly LOG_TAG="thermal-guard"

# --------------- LOGGING ----------------
log() {
    logger -t "$LOG_TAG" "$1"
    echo "[$(date '+%H:%M:%S')] $1"
}

# ------------- DEPENDENCIES -------------
check_deps() {
    command -v ryzenadj >/dev/null || {
        echo "Error: ryzenadj no instalado"
        exit 1
    }

    command -v sensors >/dev/null || {
        echo "Error: lm_sensors no instalado"
        exit 1
    }
}

# ----------- HARDWARE LAYER -------------
apply_profile() {
    local mode="$1"

    case "$mode" in
        "$MODE_TURBO")
            sudo -n /usr/bin/ryzenadj \
                --stapm-limit=32000 \
                --fast-limit=34000 \
                --slow-limit=32000 \
                --tctl-temp=85 \
                --vrm-current=70000 \
                --apu-skin-temp=45 \
                >/dev/null 2>&1
            ;;
        "$MODE_CONSERVATIVE")
            sudo -n /usr/bin/ryzenadj \
                --stapm-limit=25000 \
                --fast-limit=25000 \
                --slow-limit=25000 \
                --tctl-temp=75 \
                --vrm-current=60000 \
                --apu-skin-temp=45 \
                >/dev/null 2>&1
            ;;
    esac
}

get_current_temp() {
    sensors | awk '
        /Tctl:/ {
            gsub(/[+°C]/,"",$2)
            print int($2)
            exit
        }
    '
}

# ---------- CLEAN EXIT / RESTORE --------
cleanup() {
    log "Restaurando perfil TURBO al salir"
    apply_profile "$MODE_TURBO"
}

trap cleanup EXIT INT TERM

# ------------ CORE MONITOR --------------
run_monitor() {
    local current_mode="$MODE_TURBO"
    local high_counter=0
    local low_counter=0

    apply_profile "$MODE_TURBO"
    log "Iniciado en modo $current_mode"

    while true; do
        local temp
        temp="$(get_current_temp || true)"

        # Validar lectura
        if ! [[ "$temp" =~ ^[0-9]+$ ]]; then
            log "Lectura inválida de temperatura"
            sleep "$CHECK_INTERVAL"
            continue
        fi

        log "Temp actual: ${temp}°C | Estado: $current_mode"

        case "$current_mode" in

            "$MODE_TURBO")
                if (( temp >= TEMP_CRITICAL )); then
                    ((high_counter += CHECK_INTERVAL))
                else
                    high_counter=0
                fi

                if (( high_counter >= HOT_TIME_LIMIT )); then
                    current_mode="$MODE_CONSERVATIVE"
                    apply_profile "$current_mode"
                    notify-send "Thermal Guard" \
                        "Modo conservador activado (${temp}°C)" \
                        -u critical || true

                    log "Cambio a $current_mode"
                    high_counter=0
                fi
                ;;

            "$MODE_CONSERVATIVE")
                if (( temp <= TEMP_SAFE )); then
                    ((low_counter += CHECK_INTERVAL))
                else
                    low_counter=0
                fi

                if (( low_counter >= COOL_TIME_LIMIT )); then
                    current_mode="$MODE_TURBO"
                    apply_profile "$current_mode"
                    notify-send "Thermal Guard" \
                        "Temperatura segura. Turbo restaurado (${temp}°C)" \
                        -u normal || true

                    log "Cambio a $current_mode"
                    low_counter=0
                fi
                ;;
        esac

        sleep "$CHECK_INTERVAL"
    done
}

main() {
    check_deps
    run_monitor
}

main "$@"
