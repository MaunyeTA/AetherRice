-- ~/.config/hypr/keybinds/init.lua

local mod = "SUPER"
local shift = "SHIFT"
local alt = "ALT"

hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

-- Workspaces
for i = 1, 10 do
    local key = i % 10 
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind(mod .. " + " .. shift .." + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Apps
local terminal = "kitty"
local browser = "firefox"
local launcher = "rofi -show drun"
local vscode = "code" 
-- Added the discord keybind to launch discord with wayland decorations enabled and ozone platform hint set to auto. This is useful for users who want to run discord on wayland without any issues.
local discord = "discord --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto"

hl.bind(mod, hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + R", hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + C", hl.dsp.exec_cmd(vscode))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(discord)) 

-- Hyprland Reload
hl.bind(mod .. " + " .. shift .. " + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Media keys (volume control)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%; qs ipc call volume update"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%; qs ipc call volume update"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle; qs ipc call volume update"))

-- Microphone mute
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"))

-- Screen Brightness (using brightnessctl)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"))

-- Screenshot (using grim and slurp)
hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" ~/Pictures/Screenshots/screenshot_$(date +%F_%H-%M-%S).png"))
