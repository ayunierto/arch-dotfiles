# AGENTS.md

Dotfiles personales de Arch Linux + un instalador bash modular. Sin código de aplicación, sin tests, sin CI, sin manifiesto de paquetes.

## Cómo funciona el instalador

- `bootstrap.sh` (solo Arch, verifica `/etc/os-release`) clona el repo en `~/.dotfiles` y luego ejecuta `install.sh`.
- `install.sh` deriva `DOTFILES_DIR` de la ruta del propio script (`${BASH_SOURCE[0]}`), carga todo `lib/*.sh` y después cada `modules/*.sh` en orden léxico. **Los módulos se ejecutan al hacer source, no como funciones** - el orden lo controla el prefijo numérico (`10`..`90`). Para añadir un paso, crea `modules/NN-nombre.sh` cuyo cuerpo se ejecute de inmediato. Un fallo aborta (todos usan `set -euo pipefail`).
- Los helpers compartidos viven en `lib/`: `pkg_install` (pacman), `aur_install` (auto-instala `yay` si no hay helper AUR), `link_file`/`backup_if_needed` (symlinks, respaldando destinos existentes que no sean symlink a `<destino>.bak.<epoch>`), `user_service_enable`, `log`/`warn`/`die`.
- `modules/10-system.sh` y `modules/20-aur.sh` son la fuente de verdad de paquetes; si un config usa un binario nuevo, añádelo ahí.
- `extras/` **no** se ejecuta desde `install.sh`: cada extra trae su propio `install.sh` y `README.md` para instalarse a mano (hoy solo `extras/thermal-guard/`).

## Convenciones

- Toda la salida de scripts, comentarios y docs está en **español** - mantén eso al añadir mensajes.
- Todo es idempotente/re-ejecutable; ejecutar `./install.sh` necesita `sudo` (pacman) y solo funciona en Arch.
- El repo es la fuente de verdad: `~/.zshrc`, `~/.aliases`, `~/.exports`, `~/.gitconfig`, los temas de opencode (`~/.config/opencode/themes`) y todo lo de `~/.config/{gtk-3.0,gtk-4.0,hypr,kitty,swaync,swayosd,waybar,wofi}` son symlinks hacia este repo. Edita los archivos aquí, no las copias enlazadas.
- Los respaldos generados (`*.bak`, `*.bak.*`, `*.orig`) están en `.gitignore`; no los versiones.

## Trampas

- Evita rutas absolutas con home hardcodeado en los configs (`/home/<usuario>/...`): usa `$HOME`/`~`, o rutas relativas si el formato no expande tilde (ej. `config/hypr/hyprlock.conf` usa `$HOME`, `config/swaync/style.css` usa `../waybar/...`).
- El tema de colores va por capas, todas en el repo. Para GTK (waybar/swaync/swayosd) la paleta es `config/waybar/theme/theme.css`: swaync y swayosd lo importan como `../waybar/theme/theme.css`, igual que waybar. **wofi es la excepción**: carga el CSS con `gtk_css_provider_load_from_data`, y GTK resuelve los `@import` relativos contra el CWD del proceso, así que cualquier import falla en silencio; por eso `config/wofi/style.css` lleva la paleta de mocha copiada inline (si cambias de tema, actualízala ahí también). Para **apps GTK** el tema es la plantilla AUR `catppuccin-gtk-theme-mocha`: el `gtk-theme-name` de `config/gtk/gtk-3.0/settings.ini` (y `gtk-4.0`) es `catppuccin-mocha-blue-standard+default`, en minúsculas con `+` porque así llama el paquete a su carpeta en `/usr/share/themes` (no es el `Catppuccin-Mocha-...` de los docs del proyecto). `nwg-look` **no** está instalado: esos `settings.ini` son symlinks del repo y un GUI los violaría; `modules/45-gtk.sh` re-aplica también vía `gsettings` los valores que leen los apps libadwaita/GTK4 (`org.gnome.desktop.interface`), que **no** leen `settings.ini`. kitty (`config/kitty/current-theme.conf`) e hypr (`config/hypr/theme/theme.conf`, que hace `source` `hyprlock.conf`) usan formatos propios.
- `config/waybar/README.md` documenta el esquema real `bars/`, `modules/`, `theme/`; la barra activa se elige con el `include` de `config/waybar/config.jsonc` y el `@import` de `style.css`. El módulo `custom/deepseek` evalúa la tarifa de la API de DeepSeek en **UTC** (no hora local): los horarios peak (`01:00–04:00` y `06:00–10:00` UTC lun–vie, feriados chinos ignorados) se definen en UTC, así que el script calcula día/hora con aritmética sobre el epoch (sin `date -u`); su notificador `deepseek-peak.sh watch` se arranca desde `config/hypr/scripts/autostart/services` (el módulo usa `signal: 3` y `watch` dispara `pkill -RTMIN+3 -x waybar` para refrescar el icono al instante).
- Thermal Guard vive en `extras/thermal-guard/` (`install.sh`, `thermal-guard.sh`, `thermal-guard.service`, `README.md`) y es opcional: requiere AMD Ryzen. Crea un drop-in NOPASSWD en `/etc/sudoers.d/90-ryzenadj` y un servicio systemd de usuario. Resuelve `ryzenadj` con `command -v` (`$RYZENADJ_BIN`); no asumas `/usr/bin/ryzenadj`. El paquete `ryzenadj` sí se instala desde `modules/20-aur.sh` porque los aliases `set-power-*` de `.zshrc` lo usan.
- NVM: el instalador reutiliza `~/.config/nvm` o `~/.nvm` (el que exista) con `PROFILE=/dev/null`; `.zshrc` carga el que esté presente.

## Verificar cambios

- No hay tests, configuración de linter ni CI. `shellcheck` no está instalado.
- Sintaxis de scripts editados con `bash -n <archivo>`.
- Los `.jsonc` de waybar llevan comentarios y comas finales; valídalos con una herramienta tolerante a JSONC, no con `jq` estricto.
- Dale prioridad a los archivos ejecutables ante docs en prosa si se contradicen.
