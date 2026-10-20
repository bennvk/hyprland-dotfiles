
--               _            _             _   
--    __ _ _   _| |_ ___  ___| |_ __ _ _ __| |_ 
--   / _` | | | | __/ _ \/ __| __/ _` | '__| __|
--  | (_| | |_| | || (_) \__ \ || (_| | |  | |_ 
--   \__,_|\__,_|\__\___/|___/\__\__,_|_|   \__|
--                                            

hl.on("hyprland.start", function () 
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("waybar")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("$HOME/.config/hypr/scripts/network-watcher.sh")
  hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
end)
