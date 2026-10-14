
--               _                 _   _
--    __ _ _ __ (_)_ __ ___   __ _| |_(_) ___  _ __  ___ 
--   / _` | '_ \| | '_ ` _ \ / _` | __| |/ _ \| '_ \/ __|
--  | (_| | | | | | | | | | | (_| | |_| | (_) | | | \__ \
--   \__,_|_| |_|_|_| |_| |_|\__,_|\__|_|\___/|_| |_|___/
--                                                     

hl.config({ animations = { enabled = true } })

-- Bezier curves

hl.curve("default",        { type = "bezier", points = { {0.25, 1},  {0.5,  1}   } })
hl.curve("custom",         { type = "bezier", points = { {0.25, 1},  {0.5,  1}   } })
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},  {0.32, 1}   } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0,    0},  {1,    1}   } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5,  0.5}, {0.75, 1.0} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},  {0.1,  1}   } })

-- Animations

hl.layer_rule({    name = "waybar-slide",           match = { namespace = "waybar" },         animation = "slide top" })
hl.animation({     leaf = "workspaces",   enabled = true, speed = 5,    bezier = "custom",           style = "slide"  })
hl.animation({     leaf = "windows",      enabled = true, speed = 5,    bezier = "easeOutQuint",     style = "popin"  })
hl.animation({     leaf = "windowsOut",   enabled = true, speed = 5,    bezier = "easeInOutCubic",   style = "popin"  })
hl.animation({     leaf = "windowsMove",  enabled = true, speed = 5,    bezier = "custom"                             })
hl.animation({     leaf = "global",       enabled = true, speed = 10,   bezier = "default"                            })
hl.animation({     leaf = "border",       enabled = true, speed = 5.39, bezier = "easeOutQuint"                       })
hl.animation({     leaf = "fade",         enabled = true, speed = 10,   bezier = "default"                            })
hl.animation({     leaf = "layers",       enabled = true, speed = 3.81, bezier = "easeOutQuint"                       })
hl.animation({     leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear"                       })
hl.animation({     leaf = "fadeLayersOut",enabled = true, speed = 1.39, bezier = "almostLinear"                       })
hl.animation({     leaf = "fadeIn",       enabled = true, speed = 1.73, bezier = "almostLinear"                       })
hl.animation({     leaf = "fadeOut",      enabled = true, speed = 1.46, bezier = "almostLinear"                       })
hl.animation({     leaf = "layersIn",     enabled = true, speed = 3,    bezier = "easeOutQuint",    style = "popin"   })
hl.animation({     leaf = "layersOut",    enabled = true, speed = 3,    bezier = "easeOutQuint",    style = "popin"   })
