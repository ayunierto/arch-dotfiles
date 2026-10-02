-- Config principal del compositor en Lua (Hyprland >= 0.56).
-- Sustituye al antiguo `hyprland.conf` (hyprlang), que Hyprland 0.57 eliminará.
--
-- Este archivo solo carga los módulos de `modules/`, en el mismo orden que los
-- antiguos `source`. Hyprland elige proveedor UNA sola vez al arrancar: si existe
-- `hyprland.lua`, gana sobre `hyprland.conf` y este último queda sin leer. Ya no
-- hay ningún `hyprland.conf` en el repo, así que no hay doble autostart posible.
--
-- OJO: la elección de proveedor solo ocurre al arrancar Hyprland (o con
-- `hyprctl reload full-reset`). Un `hyprctl reload` a secas NO cambia de
-- hyprlang a Lua: hay que hacer logout/login la primera vez.
--
-- `require` resuelve relativo al directorio de este archivo (Hyprland añade
-- `<dir>/?.lua` a `package.path`), por eso los módulos se piden sin `~/`.

require("modules/monitors")
require("modules/autostart")
require("modules/programs")
require("modules/envs")
require("modules/appearance")
require("modules/permissions")
require("modules/input")
require("modules/keybinds")
require("modules/rules")
