# Arch Dotfiles

Entorno de desarrollo reproducible para Arch Linux: instalador bash modular, configs de Hyprland/Waybar/Kitty/Rofi/Wofi/SwayNC y un guard térmico para Ryzen.

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
├── modules/          # pasos del instalador (00..90)
├── config/           # hypr, kitty, rofi, swaync, waybar, wofi
├── bin/              # reload-waybar, reload-swaync, thermal-guard.sh
├── systemd/          # thermal-guard.service (usuario)
└── docs/             # guías adicionales
```

## Módulos del instalador

Se ejecutan al hacer `source`, en orden numérico:

- `10-system.sh` — paquetes base vía `pacman`
- `20-aur.sh` — paquetes AUR vía `yay`
- `30-zsh.sh` — Oh My Zsh + plugins
- `40-node.sh` — NVM + Node LTS
- `50-dotfiles.sh` — symlinks de configs
- `60-thermal.sh` — Thermal Guard (sudoers + servicio)
- `70-docker.sh` — Docker + grupo
- `90-finish.sh` — ajustes finales

## Configs

`~/.zshrc`, `~/.aliases`, `~/.exports`, `~/.gitconfig` y `~/.config/{hypr,kitty,rofi,swaync,waybar,wofi}` son symlinks a este repo. Edita aquí, no las copias enlazadas.

## Thermal Guard

Servicio de usuario que ajusta los límites de `ryzenadj` según la temperatura (modos TURBO/CONSERVATIVE). Usa un drop-in NOPASSWD en `/etc/sudoers.d/90-ryzenadj`.

## Documentación

- `docs/COMMAND_LINE_TOOLS.md`: Android SDK Command Line Tools para Expo / React Native.

## Licencia

MIT, ver `LICENSE`.
