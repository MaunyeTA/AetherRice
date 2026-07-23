-- Monitor setup
hl.monitor({
    output   = "",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1.2",
}) 

hl.env("XCURSOR_SIZE", "20")   
hl.env("HYPRCURSOR_SIZE", "20") 


hl.on("hyprland.start", function()
  hl.exec_cmd("quickshell")
  hl.exec_cmd("hyprpaper")
end)

-- General configs 
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(12, 30, 88, 0.95)", "rgba(20, 55, 171, 0.95)"}, angle = 45 },
            inactive_border = "rgba(18, 31, 77, 0.95)",
        },
 
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle", 
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

for i = 1, 10 do
    local key = i % 10 
    hl.workspace_rule({ workspace = key, persistent = true })
end

hl.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace"
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
    },
})
