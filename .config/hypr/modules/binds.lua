
--
--   _              _     _           _     
--  | | _____ _   _| |__ (_)_ __   __| |___ 
--  | |/ / _ \ | | | '_ \| | '_ \ / _` / __|
--  |   <  __/ |_| | |_) | | | | | (_| \__ \
--  |_|\_\___|\__, |_.__/|_|_| |_|\__,_|___/
--            |___/                         
--

-- Application
hl.bind("SUPER + Q", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("kitty yazi"))
hl.bind("SUPER + E", hl.dsp.window.close(activewindow))
hl.bind("SUPER + SHIFT + E", hl.dsp.window.kill())
hl.bind("SUPER + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("bash ~/.config/rofi/profiles-menu/profiles-menu.sh"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("bash ~/.config/rofi/power-menu/power-menu.sh"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("bash ~/.config/waybar/modules-scripts/toggle-waybar.sh"))

-- Windows
hl.bind("SUPER + F", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle", window = activewindow }))
    hl.dispatch(hl.dsp.window.resize({ x = "1500", y = "900", relative = false, window = activewindow }))
    hl.dispatch(hl.dsp.window.center({ window = activewindow }))
end)
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + ESCAPE", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }))

-- Clipboard
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("cliphist wipe && notify-send 'Presse papier' 'Le presse papier à bien était vidé' || notify-send '⚠️ Erreur ⚠️' 'Impossible de vider le presse paper'"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("~/.config/rofi/clipboard-menu/clipboard-menu.sh delete"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("~/.config/rofi/clipboard-menu/clipboard-menu.sh paste"))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i , follow = false}))
end
hl.bind("SUPER + mouse:275", hl.dsp.focus({ workspace = "r-1" }), { mouse = true })
hl.bind("SUPER + mouse:276", hl.dsp.focus({ workspace = "r+1" }), { mouse = true })

-- Screenshot
hl.bind("SUPER + P", hl.dsp.exec_cmd(
    "bash -c 'grim - | tee >(wl-copy) > ~/Images/Screenshots/screenshot_$(date +%s).png'"
))
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd(
    "bash -c 'coords=$(slurp) && sleep 0.1 && grim -g \"$coords\" - | tee >(wl-copy) > ~/Images/Screenshots/screenshot_$(date +%s).png'"
))

-- Brightness
hl.bind("SUPER + bracketleft", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness-control.sh down"))
hl.bind("SUPER + bracketright", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness-control.sh up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness-control.sh down"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness-control.sh up"))

-- Media
hl.bind("SUPER + F5", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("SUPER + F6", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume-control.sh down"))
hl.bind("SUPER + F7", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume-control.sh up"))
hl.bind("SUPER + F8", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume-control.sh up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume-control.sh down"))

-- Mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Layout
hl.bind("SUPER + A", hl.dsp.layout("orientationleft"))
hl.bind("SUPER + D", hl.dsp.layout("orientationright"))
hl.bind("SUPER + S", hl.dsp.layout("swapwithmaster"))
