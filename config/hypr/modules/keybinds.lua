-------------------
--- KEYBINDINGS ---
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Keywords/

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local programs = require("modules/programs")

-- OJO: los modificadores deben ir SIEMPRE primero en la lista (`SUPER + SHIFT + 1`).
-- Una tecla sin modificador se escribe SIN coma inicial: `hl.bind("XF86AudioMute", ...)`,
-- porque `", XF86AudioMute"` no parsea (el parser de keysym no lo reconoce).

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(programs.terminal))
-- `killactive` en hyprlang = cierre *amable* (envía el evento de cierre), NO es
-- `hl.dsp.window.kill()`: ese hace SIGKILL al proceso.
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- Fallback: con config Lua, `hyprctl dispatch exit` ya no vale; se despacha
-- `hl.dsp.exit()` (hyprctl lo envuelve como `hl.dispatch(...)`).
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(programs.browser))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(programs.editor))

hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("zed"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(programs.menu))
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("~/.local/bin/wofi-emoji")) -- Emojis con SUPER + .
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.local/bin/wifi-menu")) -- Menú Wi-Fi con SUPER + W
hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("pkill -USR1 -f '^bash .*wifi-menu$'")) -- Re-scanear menú Wi-Fi abierto
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle (deprecated)
-- El toggle es el default: no hace falta pasar action.
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- Screen lock bind
hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + F6", hl.dsp.dpms({ action = "toggle" })) -- Apaga/enciende la pantalla

-- Silenciar audio con SUPER + F10
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))

-- Luz cálida: toggle del filtro hyprsunset con SUPER + F9
hl.bind(mainMod .. " + F9", hl.dsp.exec_cmd("~/.config/waybar/scripts/hyprsunset.sh toggle"))

-- Partial screenshot bind and notification (guarda en ~/Pictures y copia al portapapeles)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | tee ~/Pictures/screenshot_$(date +%Y%m%d_%H%M%S).png | wl-copy && notify-send "Screenshot taken" || notify-send "Screenshot cancelled"]]))

-- Grabación de pantalla (toggle): con micrófono / solo audio del sistema
hl.bind(mainMod .. " + F8", hl.dsp.exec_cmd("~/.local/bin/screen-recorder mic")) -- Sistema + micrófono con SUPER + F8
hl.bind(mainMod .. " + SHIFT + F8", hl.dsp.exec_cmd("~/.local/bin/screen-recorder system")) -- Solo sistema con SUPER + SHIFT + F8

-- Scripts
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.local/bin/reload-waybar")) -- Reload Waybar
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("killall waybar")) -- Kill Waybar
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload")) -- Reload Hyprland

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- OJO: `relative` no aplica aquí; el selector de workspace acepta número o
-- string, así que "e+1" / "special:magic" también valen.
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move windows with arrow keys + SHIFT + mainMod
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Resize windows with mainMod + CTRL + arrows
-- OJO: `relative = true` es lo que reproduce el `resizeactive 40 0` de hyprlang
-- (delta sobre el tamaño actual). Sin `relative`, x/y son el TAMAÑO ABSOLUTO y
-- `y = 0` sería un error "Invalid size".
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
-- OJO: el `{ mouse = true }` del ejemplo de Hyprland NO existe (se ignora en
-- silencio). Las opciones reales son `click` (arrastrar) y `drag` (redimensionar),
-- y ambas activan `release` implícitamente.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { click = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { drag = true })

-- Brillo con SUPER + F1/F2
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("swayosd-client --brightness -5"), { locked = true })
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("swayosd-client --brightness +5"), { locked = true })

-- Volumen con SUPER + F11/F12
hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("swayosd-client --output-volume -5"), { locked = true })
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("swayosd-client --output-volume +5"), { locked = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness +5"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -5"), { locked = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
