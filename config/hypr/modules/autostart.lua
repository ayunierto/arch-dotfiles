-----------------
--- AUTOSTART ---
-----------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
--
-- El `exec-once` de hyprlang se dispara en el mismo evento internally que
-- `hyprland.start`, así que es el equivalente exacto. `hl.exec_cmd` corre el
-- comando vía `/bin/sh -c` (como el dispatcher `exec` de siempre).

hl.on("hyprland.start", function()
    hl.exec_cmd("$HOME/.config/hypr/scripts/autostart/services")
    hl.exec_cmd("$HOME/.config/hypr/scripts/autostart/apps")
end)
