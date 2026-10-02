-------------------
--- PERMISSIONS ---
-------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons
--
-- Todo comentado, como en el hyprlang original. Las dos formas que acepta
-- `hl.permission` son posicional o con tabla:
--   hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
--   hl.permission({ binary = "/usr/(bin|local/bin)/grim", type = "screencopy", mode = "allow" })

-- hl.config({
--     ecosystem = {
--         enforce_permissions = true,
--     },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
