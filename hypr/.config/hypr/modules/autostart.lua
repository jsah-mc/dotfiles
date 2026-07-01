-- hl.on("hyprland.start", function(
--     hl.exec_cmd("awww-daemon; swaync")
-- end)
--
hl.on("hyprland.start", function ()
  hl.exec_cmd("qs -c noctalia-shell & vicinae server & hypridle")
end)
