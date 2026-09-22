# Waybar

Config de Waybar con Catppuccin (Mocha). La barra activa se elige en `config.jsonc` con el `include` del perfil correspondiente; `style.css` importa el tema y el `.css` de la barra activa.

## Estructura

```
.
├── config.jsonc          # Barra activa (include de bars/...)
├── style.css             # Importa theme/ y la css de la barra activa
├── bars/                 # Barras: activa (top/top-bar-2) + alternativas
│   ├── top/
│   │   ├── top-bar-1.jsonc / .css   # barra superior alternativa
│   │   └── top-bar-2.jsonc / .css   # barra superior activa
│   ├── left/vertical-bar.jsonc
│   └── bottom/bottom-bar.jsonc
├── modules/              # Config por módulo (cada uno en su propio jsonc)
├── theme/                # Paleta Catppuccin (theme.css importa el esquema)
├── scripts/              # Scripts auxiliares de módulos custom
└── power_menu.xml        # Menú del botón de apagado
```

La barra activa se cambia editando el `include` de `config.jsonc` y el `@import` de `style.css` (deben apuntar a la misma barra).

## Módulo DeepSeek (horario de tarifa)

Indica en un vistazo si DeepSeek cobra tarifa completa o el **50% de descuento** por estar fuera de horas pico. Sirve para saber cuándo conviene darle uso intensivo o tirar del modelo pro.

- **Peak (caro):** `01:00–04:00` y `06:00–10:00` **UTC**, lunes a viernes.
- **Off-peak (mitad de precio):** todo lo demás, incluidos fines de semana completos.

> La evaluación se hace en **UTC**, no en hora local: en Perú (UTC-5) los bordes de día no calzan con un simple "lun–vie". Por eso el cálculo lo hace el script con `date -u`, no el `.jsonc`. Los feriados públicos chinos (en los que nunca hay peak) se ignoran.

### Componentes

- `modules/custom-deepseek.jsonc` — módulo `custom/deepseek` con `return-type: json` e `interval: 300`.
- `scripts/deepseek-peak.sh` — lógica compartida, dos modos:
  - `status` — imprime el JSON para waybar (`text`, `class`, `tooltip` con la próxima transición en hora local).
  - `watch` — bucle que lanza `notify-send` cuando cambia la tarifa (se arranca desde `config/hypr/scripts/autostart/services`).
- `bars/top/top-bar-2.css` — estilos: `.offpeak` → `@Teal`, `.peak` → `@warning`. Iconos: `󰁅` (precio baja) y `󰁔` (precio sube).

### Horario local (Perú, UTC-5)

| Estado | Horario local |
|---|---|
| Peak | Dom 20:00–23:00 · Lun–Jue 01:00–05:00 y 20:00–23:00 · Vie 01:00–05:00 |
| Off-peak | Todo lo demás (incluye jueves/sábados completos y vie desde las 23:00) |

## Operación

- Añadir un módulo: crea `modules/<nombre>.jsonc`, inclúyelo en la barra con `modules-*` y añádelo al `include`.
- Añadir un módulo custom con script: crea el script en `scripts/`, hazlo ejecutable, y despliega su estilo en la `.css` de la barra.
- Recargar la barra: `~/.local/bin/reload-waybar`.

## Troubleshooting

- Si los iconos no aparecen, instala la Nerd Font correspondiente o ajusta `font-family` en `theme/theme.css`.
- Los `.jsonc` llevan comentarios y comas finales; valídalos con una herramienta tolerante a JSONC, no con `jq` estricto.
- Si un módulo custom no aparece, verifica que esté en `modules-*` **y** en el `include` de la barra.