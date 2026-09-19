# AGENTS.md

Dotfiles personales de Arch Linux + un instalador bash modular. Sin código de aplicación, sin tests, sin CI, sin manifiesto de paquetes.

## Cómo funciona el instalador

- `bootstrap.sh` (solo Arch, verifica `/etc/os-release`) clona el repo en `~/.dotfiles` y luego ejecuta `install.sh`.
- `install.sh` deriva `DOTFILES_DIR` de la ruta del propio script (`${BASH_SOURCE[0]}`), carga todo `lib/*.sh` y después cada `modules/*.sh` en orden léxico. **Los módulos se ejecutan al hacer source, no como funciones** - el orden lo controla el prefijo numérico (`10`..`90`). Para añadir un paso, crea `modules/NN-nombre.sh` cuyo cuerpo se ejecute de inmediato. Un fallo aborta (todos usan `set -euo pipefail`).
- Los helpers compartidos viven en `lib/`: `pkg_install` (pacman), `aur_install` (auto-instala `yay` si no hay helper AUR), `link_file`/`backup_if_needed` (symlinks, respaldando destinos existentes que no sean symlink a `<destino>.bak.<epoch>`), `user_service_enable`, `log`/`warn`/`die`.
- `modules/10-system.sh` y `modules/20-aur.sh` son la fuente de verdad de paquetes; si un config usa un binario nuevo, añádelo ahí.

## Convenciones

- Toda la salida de scripts, comentarios y docs está en **español** - mantén eso al añadir mensajes.
- Todo es idempotente/re-ejecutable; ejecutar `./install.sh` necesita `sudo` (pacman) y solo funciona en Arch.
- El repo es la fuente de verdad: `~/.zshrc`, `~/.aliases`, `~/.exports`, `~/.gitconfig` y todo lo de `~/.config/{hypr,kitty,rofi,swaync,waybar,wofi}` son symlinks hacia este repo. Edita los archivos aquí, no las copias enlazadas.
- Los respaldos generados (`*.bak`, `*.bak.*`, `*.orig`) están en `.gitignore`; no los versiones.

## Trampas

- Evita rutas absolutas con home hardcodeado en los configs (`/home/<usuario>/...`): usa `$HOME`/`~`, o rutas relativas si el formato no expande tilde (ej. `config/hypr/hyprlock.conf` usa `$HOME`, `config/wofi/style.css` usa `../waybar/...`).
- `config/waybar/README.md` documenta un esquema viejo con `profiles/` + `activate-waybar.sh` que ya no existe. El esquema real es `bars/`, `modules/`, `theme/`; la barra activa se elige con el `include` de `config/waybar/config.jsonc` y el `@import` de `style.css`.
- Thermal guard instala un drop-in NOPASSWD en `/etc/sudoers.d/90-ryzenadj` y un servicio systemd de usuario (`systemd/thermal-guard.service` -> `~/.local/bin/thermal-guard.sh`). Resuelve `ryzenadj` con `command -v` (`$RYZENADJ_BIN`); no asumas `/usr/bin/ryzenadj`.
- NVM: el instalador reutiliza `~/.config/nvm` o `~/.nvm` (el que exista) con `PROFILE=/dev/null`; `.zshrc` carga el que esté presente.

## Verificar cambios

- No hay tests, configuración de linter ni CI. `shellcheck` no está instalado.
- Sintaxis de scripts editados con `bash -n <archivo>`.
- Los `.jsonc` de waybar llevan comentarios y comas finales; valídalos con una herramienta tolerante a JSONC, no con `jq` estricto.
- Dale prioridad a los archivos ejecutables ante docs en prosa si se contradicen.
