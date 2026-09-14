
--            _           _                                  
--  __      _(_)_ __   __| | _____      _____
--  \ \ /\ / / | '_ \ / _` |/ _ \ \ /\ / / __|
--   \ V  V /| | | | | (_| | (_) \ V  V /\__ \
--    \_/\_/ |_|_| |_|\__,_|\___/ \_/\_/ |___/
--

-- Windows 

hl.window_rule({ 
  match = { class = "galculator" }, 
  float = true, 
  size = {375, 500} 
}) 

hl.window_rule({ 
  match = { class = "swayimg" }, 
  float = true, 
  size = {1000, 550}
})

hl.window_rule({ 
  match = { class = "xdg-desktop-portal-gtk" }, 
  float = true, 
  size = {1250, 800},
  center = true
})

hl.window_rule({ 
  match = { class = "localsend" }, 
  float = true, 
  size = {1250, 800},
  center = true
})
