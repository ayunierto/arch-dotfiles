# Utilidades

Wrappers propios en `bin/`, enlazados como symlinks en `~/.local/bin`.

## Emojis (wofi-emoji)

Selector de emojis integrado con el lanzador wofi. Se abre con `SUPER + .` (`config/hypr/modules/keybinds.lua`) y, al pulsar `Enter`, teclea el emoji directamente en el campo enfocado vía `wtype` (o lo copia al portapapeles con `wl-copy`). La tecla enlaza el wrapper `bin/wofi-emoji` (symlink en `~/.local/bin`, por ruta completa porque el PATH de Hyprland no incluye `~/.local/bin`); el wrapper reutiliza la lista de emojis del paquete AUR y, en apps Chromium/Electron (VSCode, Discord, Chrome...), inserta el emoji por portapapeles + `Ctrl+V` simulado porque `wtype` no teclea bien ciertos caracteres en esas apps. Dependencias: `wofi`, `wl-clipboard`, `wtype` (`modules/10-system.sh`), `wofi-emoji` desde AUR (`modules/20-aur.sh`) y `jq`. El renderizado usa `noto-fonts-emoji`.

## Wi-Fi (wifi-menu)

Menú Wi-Fi lanzado con `SUPER + W` (`config/hypr/modules/keybinds.lua`) vía el wrapper `bin/wifi-menu` (symlink en `~/.local/bin`, por ruta completa porque el PATH de Hyprland no incluye `~/.local/bin`). Lista las redes escaneadas con `nmcli`, marcando la conectada (`◉`) y mostrando barras de intensidad; se conecta a redes guardadas con `nmcli connection up` y pide la contraseña en el resto. El item `🔍 Re-scanear` fuerza un escaneo nuevo sin cerrar el flujo. Dependencias: `nmcli` (NetworkManager, habilitado en `modules/10-system.sh`), `wofi` y `libnotify` (`modules/10-system.sh`).

## Grabación de pantalla (screen-recorder)

Grabador con `SUPER + F8` (audio del sistema + micrófono, mezclados) y `SUPER + SHIFT + F8` (solo audio del sistema); ambos son toggle, se pulsan otra vez para detener. Enlaza el wrapper `bin/screen-recorder` (symlink en `~/.local/bin`) y usa `wf-recorder`, guardando en `~/Videos` como `rec_<fecha>.mp4` (`$XDG_VIDEOS_DIR` si existe). Al detener avisa por `notify-send` con la ruta, la duración y el tamaño. El estado (PID, archivo y módulos de audio cargados) vive en `$XDG_RUNTIME_DIR`, así que si la máquina se reinicia no quedan sumideros virtuales de audio huérfanos.

Dos detalles que no son obvios:

- wf-recorder 0.6 se llama siempre con `--audio-backend=pulse`. Con el valor por defecto `auto` no crea lector de audio y graba **en silencio sin avisar**, y con el backend `pipewire` los nombres de dispositivo se comparan contra el `node.name` nativo, donde `algo.monitor` no existe. Con `pulse` los nombres son los de `pactl` (pipewire-pulse los publica).
- El modo con micrófono carga un `module-null-sink` virtual más dos `module-loopback` (micrófono y monitor del sink por defecto) y graba `screen-recorder-mix.monitor`. Los IDs que devuelve `pactl load-module` se guardan y se descargan **por ID** al detener; nunca con `unload-module module-null-sink`, que también mataría sumideros virtuales ajenos. El null-sink se crea con `device.idle_timeout=0` para que no se suspenda en silencio y corte la pista de audio.

Dependencias: `wf-recorder` y `libnotify` (`modules/10-system.sh`); `pactl` viene con `pipewire-pulse`.
