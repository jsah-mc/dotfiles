local programs = require("modules.programs")
local mainMod = "SUPER"
local ipc = "qs -c noctalia-shell ipc call " -- Kept trailing space for clean concatenation

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(programs.terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("zeditor"))

-- Launcher
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(ipc .. "launcher toggle"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("vicinae toggle"))

-- Windows
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Noctalia UI / Quick Access
hl.bind(mainMod .. " + C",
    hl.dsp.exec_cmd(ipc .. "controlCenter toggle"))

hl.bind(mainMod .. " + SHIFT + V",
    hl.dsp.exec_cmd(ipc .. "launcher clipboard"))

hl.bind(mainMod .. " + SHIFT + W",
    hl.dsp.exec_cmd(ipc .. "wallpaper toggle")) -- Updated to reference the native selector

hl.bind(mainMod .. " + SHIFT + T",
    hl.dsp.exec_cmd(ipc .. "darkMode toggle")) -- Updated to native system darkMode toggle

hl.bind(mainMod .. " + TAB",
    hl.dsp.exec_cmd(ipc .. "launcher windows"))

-- System / Power Management
hl.bind(mainMod .. " + L",
    hl.dsp.exec_cmd(ipc .. "lockScreen lock"))

hl.bind(mainMod .. " + ESCAPE",
    hl.dsp.exec_cmd(ipc .. "sessionMenu toggle")) -- Replaced panel-toggle with specific sessionMenu

hl.bind(mainMod .. " + ESCAPE + E",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))

-- Focus
hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "down" }))

-- Screenshot
hl.bind("Print",
    hl.dsp.exec_cmd("noctalia msg screenshot-region"))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind(mainMod .. " + S",
    hl.dsp.workspace.toggle_special("magic"))

hl.bind(mainMod .. " + SHIFT + S",
    hl.dsp.window.move({ workspace = "special:magic" }))

-- Workspace scrolling
hl.bind(mainMod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" }))

-- Move/Resize windows
hl.bind(mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true })

hl.bind(mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true })

-- Hardware Control: Audio Management
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(ipc .. "volume increase"),
    { locked = true, repeating = true })

hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd(ipc .. "volume decrease"),
    { locked = true, repeating = true })

hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd(ipc .. "volume muteOutput"),
    { locked = true })

hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd(ipc .. "volume muteInput"),
    { locked = true })

-- Hardware Control: Display & Brightness
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd(ipc .. "brightness increase"),
    { locked = true, repeating = true })

hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd(ipc .. "brightness decrease"),
    { locked = true, repeating = true })

-- Media Control
hl.bind("XF86AudioPlay",
    hl.dsp.exec_cmd(ipc .. "media playPause"),
    { locked = true })

hl.bind("XF86AudioPause",
    hl.dsp.exec_cmd(ipc .. "media playPause"),
    { locked = true })

hl.bind("XF86AudioNext",
    hl.dsp.exec_cmd(ipc .. "media next"),
    { locked = true })

hl.bind("XF86AudioPrev",
    hl.dsp.exec_cmd(ipc .. "media previous"),
    { locked = true })
