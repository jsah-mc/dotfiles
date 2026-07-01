hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Zoom Workplace Exceptions: Prevent window tiling and force floating
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ match = { title = "^(Zoom Meeting)$" }, float = true })
hl.window_rule({ match = { class = "^(us.zoom.Zoom)$" }, float = true }) -- For Flatpak version

-- Optional: Center the main menu or popups when they launch
hl.window_rule({ match = { class = "^(zoom)$" }, center = true })


-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
