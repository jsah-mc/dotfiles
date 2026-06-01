hl.on("hyprland.start", function()
    hl.exec_cmd("bash -lc 'quickshell -n --daemonize --config jsah >/dev/null 2>&1; awww-daemon; swaync'")
end)
