-------------------
--- MY PROGRAMS ---
-------------------

-- See https://wiki.hypr.land/Configuring/Keywords/
--
-- Este módulo no toca nada por sí solo: solo exporta la tabla de programas que
-- usa `modules/keybinds.lua` (equivalente a las variables `$terminal`, etc.).

return {
    terminal = "kitty",
    fileManager = "dolphin",
    menu = "wofi --show drun",
    browser = "chromium",
    editor = "code",
}
