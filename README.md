# Arch Dotfiles

Entorno de desarrollo reproducible para Arch Linux: instalador bash modular y configs de Hyprland/Waybar/Kitty/Rofi/Wofi/SwayNC, con extras opcionales.

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
├── config/           # hypr, kitty, rofi, swaync, waybar, wofi
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
- `50-dotfiles.sh` — symlinks de configs
- `70-docker.sh` — Docker + grupo
- `90-finish.sh` — ajustes finales

## Configs

`~/.zshrc`, `~/.aliases`, `~/.exports`, `~/.gitconfig` y `~/.config/{hypr,kitty,rofi,swaync,waybar,wofi}` son symlinks a este repo. Edita aquí, no las copias enlazadas.

### Waybar

La barra activa es `config/waybar/bars/top/top-bar-2.jsonc`. Incluye un módulo **DeepSeek** (`config/waybar/modules/custom-deepseek.jsonc`) que muestra con un icono de color si la API está en horario **peak** (tarifa completa) u **off-peak** (50% de descuento), evaluado en UTC; un script (`config/waybar/scripts/deepseek-peak.sh watch`) avisa con `notify-send` al cambiar de tarifa. Detalles en `config/waybar/README.md`.

### Emojis (wofi-emoji)

Selector de emojis integrado con el lanzador wofi. Se abre con `SUPER + .` (`config/hypr/modules/keybinds.conf`) y, al pulsar `Enter`, teclea el emoji directamente en el campo enfocado vía `wtype` (o lo copia al portapapeles con `wl-copy`). Dependencias: `wofi`, `wl-clipboard`, `wtype` (`modules/10-system.sh`) y `wofi-emoji` desde AUR (`modules/20-aur.sh`). El renderizado usa `noto-fonts-emoji`.

## Extras opcionales

No forman parte de `install.sh`; se instalan aparte porque son específicos de un perfil concreto:

- **Thermal Guard** (`extras/thermal-guard/`): ajuste automático de potencia en AMD Ryzen por temperatura. Instrucciones en `extras/thermal-guard/README.md`.

## Documentación

- `docs/COMMAND_LINE_TOOLS.md`: Android SDK Command Line Tools para Expo / React Native.

## Licencia

MIT, ver `LICENSE`.
