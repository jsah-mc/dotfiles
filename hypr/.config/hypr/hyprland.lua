-- Hyprland Lua Configuration
-- Splitted into modules for better organization

-- Import basic settings and environment
require("modules.env")
local programs = require("modules.programs")

-- Import core modules
require("modules.monitors")
require("modules.appearance")
require("modules.input")
require("modules.autostart")
require("modules.binds")
require("modules.rules")
