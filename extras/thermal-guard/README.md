# Thermal Guard (extra opcional)

Ajusta dinámicamente los límites de potencia de un **AMD Ryzen** según la temperatura, alternando entre los modos `TURBO` y `CONSERVATIVE`. Está pensado para un perfil personal (portátil Ryzen 7), por eso **no forma parte de `install.sh`**: se instala aparte y a conciencia.

## Requisitos

- Arch Linux.
- CPU AMD Ryzen compatible con `ryzenadj`.
- `ryzenadj` (AUR) y `lm_sensors`.
- Un servicio systemd **de usuario** (no requiere root permanente, pero sí un drop-in NOPASSWD acotado a `ryzenadj`).

## Instalación automática

```bash
cd ~/.dotfiles
./extras/thermal-guard/install.sh
```

El script es idempotente: instala `lm_sensors` y `ryzenadj` si faltan, crea `/etc/sudoers.d/90-ryzenadj` resolviendo la ruta real de `ryzenadj` (`command -v`), enlaza el ejecutable y el servicio, y habilita/arranca `thermal-guard.service`.

## Instalación manual (equivalente)

```bash
# 1. Dependencias
sudo pacman -S --needed lm_sensors
yay -S --needed ryzenadj

# 2. Sudoers: NOPASSWD solo para el binario de ryzenadj (no para todo)
sudo tee /etc/sudoers.d/90-ryzenadj >/dev/null <<EOF
$USER ALL=(ALL) NOPASSWD: $(command -v ryzenadj)
EOF
sudo chmod 440 /etc/sudoers.d/90-ryzenadj
sudo visudo -cf /etc/sudoers.d/90-ryzenadj

# 3. Enlazar ejecutable y servicio
mkdir -p ~/.local/bin ~/.config/systemd/user
ln -sfn ~/.dotfiles/extras/thermal-guard/thermal-guard.sh ~/.local/bin/thermal-guard.sh
ln -sfn ~/.dotfiles/extras/thermal-guard/thermal-guard.service ~/.config/systemd/user/thermal-guard.service
chmod +x ~/.local/bin/thermal-guard.sh

# 4. Servicio de usuario
systemctl --user daemon-reload
systemctl --user enable --now thermal-guard.service
```

## Ver y controlar el servicio

```bash
systemctl --user status thermal-guard.service
journalctl --user -u thermal-guard.service -f
systemctl --user restart thermal-guard.service
```

## Umbrales

Se editan al inicio de `extras/thermal-guard/thermal-guard.sh`:

| Variable | Por defecto | Descripción |
|---|---|---|
| `TEMP_CRITICAL` | 80 | °C a partir de los que se pasa a conservador |
| `TEMP_SAFE` | 65 | °C por debajo de los que se vuelve a turbo |
| `HOT_TIME_LIMIT` | 30 | segundos calientes sostenidos antes de cambiar |
| `COOL_TIME_LIMIT` | 20 | segundos fríos sostenidos antes de volver |
| `CHECK_INTERVAL` | 5 | segundos entre chequeos |

Tras editar, reinicia el servicio. Al salir (`EXIT`/`INT`/`TERM`) restaura el perfil `TURBO`.

## Aliases `set-power-*`

`.zshrc` incluye aliases (`set-power-perf`, `set-power-extreme`, `set-power-eco`, `set-power-optimus-85`) que usan `ryzenadj`. `ryzenadj` sí se instala desde el instalador general (`modules/20-aur.sh`), así que los aliases funcionan aunque no instales este extra. El extra solo añade el ajuste automático por temperatura.

## Desinstalación

```bash
systemctl --user disable --now thermal-guard.service
rm -f ~/.config/systemd/user/thermal-guard.service
rm -f ~/.local/bin/thermal-guard.sh
sudo rm -f /etc/sudoers.d/90-ryzenadj
```
