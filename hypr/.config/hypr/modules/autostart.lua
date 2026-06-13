hl.on("hyprland.start", function()
    hl.exec_cmd("bash -lc 'kde-material-you-colors --dark --pywal --autostart >/dev/null 2>&1 & disown; quickshell -n --daemonize --config jsah >/dev/null 2>&1; awww-daemon; swaync'")
end)
