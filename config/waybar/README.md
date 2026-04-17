# Waybar Dotfiles

Configuraciones de Waybar con perfiles alternos para barra izquierda y barra superior. Incluye script para activar perfiles mediante symlinks.

## Estructura

```
.
├── activate-waybar.sh        # Script para activar un perfil (crea symlinks)
├── colors/
│   ├── catppuccin-mocha.css
│   └── colors.css
├── config.jsonc              # Symlink al perfil activo
├── style.css                 # Symlink al perfil activo
└── profiles/
    ├── left/
    │   ├── config.jsonc
    │   └── style.css
    └── top/
        ├── config.jsonc
        └── style.css
```

## Requisitos

- Waybar instalado y leyendo `~/.config/waybar/`.
- `bash` para el script de activación.
- Fuentes que uses en CSS (ej. Maple Mono NF).

## Uso rápido

1. Haz ejecutable el script (ya marcado):
   ```bash
   chmod +x activate-waybar.sh
   ```
2. Activa un perfil:
   ```bash
   ./activate-waybar.sh left   # barra vertical izquierda
   ./activate-waybar.sh top    # barra horizontal superior
   ```
3. Reinicia Waybar si no se recarga solo.

El script crea symlinks `config.jsonc` y `style.css` apuntando al perfil seleccionado.

## Perfil actual

El perfil activo se determina por los symlinks en `~/.config/waybar/`. Ejecuta `ls -l config.jsonc style.css` para ver a qué perfil apuntan.

## Troubleshooting

- Si no ves Waybar, verifica que los symlinks apunten a archivos existentes y que Waybar tenga permisos de lectura.
- Si los iconos no aparecen, instala la Nerd Font correspondiente o ajusta `font-family` en `style.css`.
- Si los comentarios JSONC fallan, elimina comentarios al validar con herramientas que requieran JSON puro.
