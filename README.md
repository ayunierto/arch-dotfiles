# Arch Dotfiles

Entorno de desarrollo reproducible para Arch Linux: instalador bash modular y configs de Hyprland/Waybar/Kitty/Wofi/SwayNC, con extras opcionales.

## Instalación rápida

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ayunierto/arch-dotfiles/main/bootstrap.sh)"
```

## Instalación manual

```bash
git clone https://github.com/ayunierto/arch-dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Requiere Arch Linux y `sudo`. Es idempotente: los archivos existentes se respaldan como `<archivo>.bak.<epoch>` antes de reemplazarse por symlinks.

## Estructura

```
.dotfiles/
├── bootstrap.sh      # clona el repo y lanza install.sh (solo Arch)
├── install.sh        # carga lib/ y ejecuta modules/ en orden
├── lib/              # helpers (pacman, AUR, symlinks, systemd, logs)
├── modules/          # pasos del instalador (10..90)
├── config/           # gtk, hypr, kitty, opencode, swaync, swayosd, waybar, wofi
├── bin/              # reload-waybar, reload-swaync
├── docs/             # guías adicionales
└── extras/           # extras opcionales (no los instala install.sh)
```

## Módulos del instalador

Se ejecutan al hacer `source`, en orden numérico:

- `10-system.sh` — paquetes base vía `pacman`
- `20-aur.sh` — paquetes AUR vía `yay`
- `30-zsh.sh` — Oh My Zsh + plugins
- `40-node.sh` — NVM + Node LTS
- `45-gtk.sh` — tema GTK y cursor vía gsettings (libadwaita/GTK4)
- `50-dotfiles.sh` — symlinks de configs
- `70-docker.sh` — Docker + grupo
- `90-finish.sh` — ajustes finales

## Configs

`~/.zshrc`, `~/.aliases`, `~/.exports`, `~/.gitconfig`, los temas de opencode (`~/.config/opencode/themes`) y `~/.config/{gtk-3.0,gtk-4.0,hypr,kitty,swaync,swayosd,waybar,wofi}` son symlinks a este repo. Edita aquí, no las copias enlazadas.

### Tema

Los colores se definen por capas, todas versionadas en este repo:

- **waybar, swaync y swayosd** leen `config/waybar/theme/theme.css` vía `@import '../waybar/theme/theme.css'`. Ese archivo importa la paleta activa (`catppuccin-mocha.css` o `catppuccin-latte.css`) — cambiarlo migra el tema de los tres a la vez.
- **Apps GTK** (Dolphin, diálogos GTK, etc.) usan una plantilla Catppuccin Mocha instalada desde AUR (`catppuccin-gtk-theme-mocha`, variante `catppuccin-mocha-blue-standard+default`) más cursores `catppuccin-cursors-mocha`. El tema, fuente, iconos (`Papirus-Dark`) y cursor se aplican en `config/gtk/gtk-3.0/settings.ini` y `config/gtk/gtk-4.0/settings.ini` (symlinks) y, para los apps libadwaita/GTK4 que solo leen dconf, en `modules/45-gtk.sh` vía `gsettings`. El nombre del tema debe coincidir con la carpeta en `/usr/share/themes` (el de AUR va en minúsculas, `+` incluido).
- **opencode** tiene su tema `config/opencode/themes/catppuccin-mocha-blue.json` (symlink en `~/.config/opencode/themes`), definido para coincidir con la paleta Catppuccin del resto.
- **kitty** (`config/kitty/current-theme.conf`) e **hypr** (`config/hypr/theme/theme.conf`, que `hyprlock.conf` hace `source`) usan formatos propios.

### Waybar

La barra activa es `config/waybar/bars/top/top-bar-2.jsonc`. Incluye un módulo **DeepSeek** (`config/waybar/modules/custom-deepseek.jsonc`) que muestra con un icono de color si la API está en horario **peak** (tarifa completa) u **off-peak** (50% de descuento), evaluado en UTC; un script (`config/waybar/scripts/deepseek-peak.sh watch`) avisa con `notify-send` al cambiar de tarifa. Detalles en `config/waybar/README.md`.

### Atajos de teclado

Definidos en `config/hypr/modules/keybinds.conf` (modificador principal `$mainMod = SUPER`):

| Atajo | Acción |
| --- | --- |
| `SUPER + Enter` | Terminal |
| `SUPER + Q` | Cerrar ventana activa |
| `SUPER + M` | Apagar / salir de la sesión |
| `SUPER + E` | Gestor de archivos |
| `SUPER + B` | Navegador |
| `SUPER + C` | Editor |
| `SUPER + Z` | Zed |
| `SUPER + R` | Menú (wofi) |
| `SUPER + .` | Selector de emojis (wofi-emoji) |
| `SUPER + V` | Activar/desactivar floating |
| `SUPER + P` | Modo pseudotileado (dwindle) |
| `SUPER + F` | Pantalla completa |
| `SUPER + F6` | Bloquear pantalla (hyprlock) |
| `SUPER + SHIFT + F6` | Apagar/encender pantallas (DPMS) |
| `SUPER + SHIFT + S` | Captura parcial: guarda en `~/Pictures` y copia al portapapeles |
| `SUPER + [1-9,0]` | Cambiar workspace |
| `SUPER + SHIFT + [1-9,0]` | Mover ventana a workspace |
| `SUPER + Flechas` | Mover foco |
| `SUPER + SHIFT + Flechas` | Mover ventana |
| `SUPER + CTRL + Flechas` | Redimensionar ventana |
| `SUPER + F1/F2` | Brillo `-5`/`+5` |
| `SUPER + F10` | Silenciar audio |
| `SUPER + F11/F12` | Volumen `-5`/`+5` |
| `SUPER + SHIFT + W` | Recargar Waybar |
| `SUPER + SHIFT + R` | Recargar Hyprland |
| `SUPER + Rueda` | Navegar workspaces |
| `SUPER + LMB/RMB` (arrastrando) | Mover/redimensionar ventana |
| Teclas multimedia | Volumen, silencio y brillo |

### Emojis (wofi-emoji)

Selector de emojis integrado con el lanzador wofi. Se abre con `SUPER + .` (`config/hypr/modules/keybinds.conf`) y, al pulsar `Enter`, teclea el emoji directamente en el campo enfocado vía `wtype` (o lo copia al portapapeles con `wl-copy`). La tecla enlaza el wrapper `bin/wofi-emoji` (symlink en `~/.local/bin`, por ruta completa porque el PATH de Hyprland no incluye `~/.local/bin`); el wrapper reutiliza la lista de emojis del paquete AUR y, en apps Chromium/Electron (VSCode, Discord, Chrome...), inserta el emoji por portapapeles + `Ctrl+V` simulado porque `wtype` no teclea bien ciertos caracteres en esas apps. Dependencias: `wofi`, `wl-clipboard`, `wtype` (`modules/10-system.sh`), `wofi-emoji` desde AUR (`modules/20-aur.sh`) y `jq`. El renderizado usa `noto-fonts-emoji`.

## Extras opcionales

No forman parte de `install.sh`; se instalan aparte porque son específicos de un perfil concreto:

- **Thermal Guard** (`extras/thermal-guard/`): ajuste automático de potencia en AMD Ryzen por temperatura. Instrucciones en `extras/thermal-guard/README.md`.

## Documentación

- `docs/COMMAND_LINE_TOOLS.md`: Android SDK Command Line Tools para Expo / React Native.

## Licencia

MIT, ver `LICENSE`.
