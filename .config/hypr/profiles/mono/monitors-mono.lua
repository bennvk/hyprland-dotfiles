
--                           _                 
--   _ __ ___   ___  _ __ (_) |_ ___  _ __ ___ 
--  | '_ ` _ \ / _ \| '_ \| | __/ _ \| '__/ __|
--  | | | | | | (_) | | | | | || (_) | |  \__ \
--  |_| |_| |_|\___/|_| |_|_|\__\___/|_|  |___/
--   

hl.monitor({ output = "eDP-1", mode = "highres@highrr", position = "0x0", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" })
