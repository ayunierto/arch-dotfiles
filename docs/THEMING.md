# Sistema de temas

Los colores se definen por capas, todas versionadas en este repo:

- **waybar, swaync y swayosd** leen `config/waybar/theme/theme.css` vía `@import '../waybar/theme/theme.css'`. Ese archivo importa la paleta activa (`catppuccin-mocha.css` o `catppuccin-latte.css`) — cambiarlo migra el tema de los tres a la vez. **wofi es la excepción**: carga su CSS con `gtk_css_provider_load_from_data` y GTK resuelve los `@import` relativos contra el CWD, así que `config/wofi/style.css` lleva la paleta de mocha copiada inline — al cambiar de tema, actualízala ahí también.
- **Apps GTK** (Dolphin, diálogos GTK, etc.) usan una plantilla Catppuccin Mocha instalada desde AUR (`catppuccin-gtk-theme-mocha`, variante `catppuccin-mocha-blue-standard+default`) más cursores `catppuccin-cursors-mocha`. El tema, la fuente **SF Pro Text** (AUR `otf-san-francisco`/`otf-san-francisco-mono`), iconos (`Papirus-Dark`) y cursor se aplican en `config/gtk/gtk-3.0/settings.ini` y `config/gtk/gtk-4.0/settings.ini` (symlinks) y, para los apps libadwaita/GTK4 que solo leen dconf, en `modules/45-gtk.sh` vía `gsettings`. El nombre del tema debe coincidir con la carpeta en `/usr/share/themes` (el de AUR va en minúsculas, `+` incluido).
- **opencode** tiene su tema `config/opencode/themes/catppuccin-mocha-blue.json` (symlink en `~/.config/opencode/themes`), definido para coincidir con la paleta Catppuccin del resto.
- **kitty** (`config/kitty/current-theme.conf`) e **hypr** (`config/hypr/theme/theme.conf`, que `hyprlock.conf` hace `source`) usan formatos propios.
