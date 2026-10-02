------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/ for workspace rules
--
-- OJO: en `hl.window_rule` / `hl.layer_rule` los `match` van en la subtabla
-- `match`, pero los EFECTOS (`suppress_event`, `no_focus`, `move`, `float`, …)
-- son claves de primer nivel de la misma tabla.

-- Example windowrules that are useful

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move = "20 monitor_h-120",
    float = true,
})

-----------------
--- LAYERRULES ---
-----------------

-- Blur rules for specific apps

hl.layer_rule({
    name = "blur-swaync-control-center",
    match = { namespace = "swaync-control-center" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "ignorealpha-swaync-notification-window",
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "blur-wofi",
    match = { namespace = "wofi" },
    blur = true,
    -- ignore_alpha = 0.5,
})
