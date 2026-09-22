# Plan: eliminar rofi y unificar la paleta de colores

Fecha: 2026-09-21. Vertido a disco antes de ejecutar los cambios.

## Contexto

- La paleta de referencia es **Catppuccin Mocha**, definida de forma duplicada en
  `config/hypr/theme/theme.conf` (sintaxis Hypr) y `config/waybar/theme/catppuccin-mocha.css`
  (GTK). `catppuccin-latte.css` también existe para un futuro selector de tema.
- **rofi no se usa**: el lanzador de apps es `$menu = wofi --show drun` en
  `config/hypr/modules/default-software.conf`, y el emoji picker es `wofi-emoji`
  (`SUPER + .`). Los configs de rofi están colgando y con una paleta que no es Mocha exacta.
- **wofi se mantiene** (es el lanzador real) junto con `wofi-emoji`, `blur-wofi`, etc.

## Objetivo

1. Quitar rofi de configs, instalador y docs.
2. Hacer de `config/waybar/theme/theme.css` la **única fuente de verdad GTK** para que
   waybar + swaync + swayosd cambien de tema juntos al editar un solo `@import`.

---

## Parte 1 — Eliminar rofi

| Archivo | Cambio |
|---|---|
| `modules/10-system.sh` (línea 11) | Quitar `rofi` de la lista de paquetes. Queda: `waybar swaync wofi kitty swayosd`. |
| `modules/50-dotfiles.sh` (línea 12) | Borrar `link_file "$DOTFILES_DIR/config/rofi" "$HOME/.config/rofi"`. |
| `config/rofi/` | Borrar todo el directorio: `config.rasi`, `colors/catppuccin.rasi`, `launchers/type-2/` (launcher.sh, shared/{colors,fonts}.rasi, style-2.rasi). |
| `README.md` (líneas 3, 29, 49) | Quitar `rofi` de la descripción, del árbol de estructura y de la lista de symlinks. |
| `AGENTS.md` (línea 17) | Quitar `rofi` de `~/.config/{hypr,kitty,rofi,swaync,waybar,wofi}`. |

No hay más referencias a rofi en el repo (keybinds, emoji, `.aliases`, `.exports`, docs).

## Parte 2 — swayosd: una sola fuente de verdad

`swayosd-server` se lanza sin `-s` (`config/hypr/scripts/autostart/services`), así que lee
automáticamente `~/.config/swayosd/style.css`. Igual que swaync, puede importar la paleta única.

Reescribir `config/swayosd/style.css`:

```css
/* SwayOSD - hereda la paleta única de config/waybar/theme/theme.css */
@import '../waybar/theme/theme.css';

window#osd {
  border-radius: 999px;
  border: none;
  background: alpha(@background, 0.85);
}

window#osd #container {
  margin: 16px;
}

window#osd image,
window#osd label {
  color: @foreground;
}

window#osd progressbar:disabled,
window#osd image:disabled {
  opacity: 0.5;
}

window#osd progressbar,
window#osd segmentedprogress {
  min-height: 6px;
  border-radius: 999px;
  background: transparent;
  border: none;
}

window#osd trough,
window#osd segment {
  min-height: inherit;
  border-radius: inherit;
  border: none;
  background: alpha(@Overlay0, 0.5);
}

window#osd progress,
window#osd segment.active {
  min-height: inherit;
  border-radius: inherit;
  border: none;
  background: @primary;
}
```

Equivalencias vs. el tema actual (hex hardcodeados): Base→`@background` (0.85),
Text→`@foreground`, Overlay0→`@Overlay0` (0.5), Blue→`@primary`. Misma apariencia,
pero todo sale de `theme.css`.

Efecto colateral: `theme.css` incluye `* { font-family: "Maple Mono NF", ... }`, que
también aplica al texto del OSD (consistente con waybar/swaync).

**Validación**: `swayosd-client --output-volume 20` (y brillo) + revisar
`journalctl` por warnings de CSS. Si fallara el import, el OSD volvería al estilo por
defecto y quedaría visible en el log.

## Parte 3 — Documentación y fuente única

- **AGENTS.md**, sección "Trampas": actualizar la nota de rutas relativas para indicar que
  `swaync` y `swayosd` importan `../waybar/theme/theme.css` como fuente única GTK; kitty y
  hypr usan sus propios formatos (`current-theme.conf` / `theme.conf`).
- **README.md**: (opcional) nota en "Configs" sobre la fuente única de colores y que
  cambiar `theme.css` migra el tema de waybar + swaync + swayosd (mocha ↔ latte ya existen).

### Selector de tema futuro (notas)

- GTK (waybar/swaync/swayosd): basta editar `config/waybar/theme/theme.css` (el motor del
  selector solo cambia ese archivo).
- kitty (`config/kitty/current-theme.conf`) e hypr (`config/hypr/theme/theme.conf`) usan
  sintaxis propia; un selector completo debería regenerar esos tres formatos desde un único
  YAML (fuera de alcance de este plan).

## Opcional (pendiente de confirmación del usuario)

Correcciones de paleta detectadas en la auditoría previa, no incluidas salvo OK:

- `config/hypr/modules/appearance.conf`: bordes `rgba(33ccff99)` / `rgba(00ff9911)` y
  `col.inactive_border rgba(595959aa)` están fuera de paleta. Pueden pasar a variables de
  `theme.conf` si `hyprland.conf` hace `source` de `config/hypr/theme/theme.conf`
  (hoy no lo hace; solo `hyprlock`).
- `config/hypr/hyprlock.conf`: `$color7` (3 usos) no está definido; `check_color`/
  `fail_color`/`font_color` fuera de paleta.
- `config/waybar/modules/custom-notifications.jsonc`: `#ed8796` es Macchiato Red; Mocha Red
  es `#F38BA8`.
- `config/waybar/bars/top/top-bar-1.css` y `top-bar-2.css`: `#64727d` fuera de paleta
  (→ `@Subtext0` o `@Overlay2`).