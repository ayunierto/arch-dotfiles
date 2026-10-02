----------------
--- MONITORS ---
----------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@60",
    position = "auto",
    scale = 1,
})

-- ############################
-- # Monitor virtual HEADLESS #
-- ############################
-- # Crear monitor virtual al iniciar Hyprland
-- hl.on("hyprland.start", function()
--     hl.exec_cmd("hyprctl output create headless")
-- end)
-- # Configurar resolución del monitor virtual
-- hl.monitor({ output = "HEADLESS-2", mode = "1366x768@60", position = "auto", scale = 1 })
-- # Asignar workspace fijo al monitor virtual
-- hl.workspace_rule({ workspace = "4", monitor = "HEADLESS-2" })

-- # WayVNC autostart
-- hl.on("hyprland.start", function()
--     hl.exec_cmd("wayvnc --max-fps 30 -o HEADLESS-2 0.0.0.0")
-- end)
