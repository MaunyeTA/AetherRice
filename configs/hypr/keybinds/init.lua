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
local discord = "discord --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto"

hl.bind(mod .. " + R", hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + C", hl.dsp.exec_cmd(vscode))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(discord)) 

-- Hyprland Reload
hl.bind(mod .. " + " .. shift .. " + R", hl.dsp.exec_cmd("hyprctl reload"))
