local terminal = "foot"
local fileManager = "yazi"
local menu = "wmenu-run"
local mainMod = "SUPER"
local resizeStep = 80

hl.monitor({
    output = "DP-2",
    mode = "5120x1440@240",
    scale = 1,
    bitdepth = 10,
    cm = "srgb",
    vrr = 0,
    sdr_min_luminance = 0.005,
    sdr_max_luminance = 250,
    sdrbrightness = 1.00,
    sdrsaturation = 1.00,
    max_luminance = 430,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("mako & waybar & firefox & discord & steam")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    ecosystem = {
        no_update_news = true,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        col = {
            active_border = "rgba(33ccffee)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
        rounding_power = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = false,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        vrr = 1,
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
    cursor = {
        inactive_timeout = 1,
    },
    input = {
        kb_layout = "pl",
        kb_variant = "",
        kb_options = "caps:escape",
        kb_model = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(terminal .. " " .. fileManager))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + R", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))


hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimshot copy area"))
--
hl.bind( mainMod .. " + ALT + right", hl.dsp.window.move({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind( mainMod .. " + ALT + left", hl.dsp.window.move({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind( mainMod .. " + ALT + up", hl.dsp.window.move({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind( mainMod .. " + ALT + down", hl.dsp.window.move({ x = 0, y = 20, relative = true }), { repeating = true })

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({x=-20, y=0,relative=true}), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({x=0, y=-20,relative=true}), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({x=0 ,y=20,relative=true}), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({x=20, y=0,relative=true}), { repeating = true })

hl.bind(mainMod .. " + X", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


hl.bind("mouse:276", hl.dsp.exec_cmd("gdbus call --session --dest net.sourceforge.mumble.mumble --object-path / --method net.sourceforge.mumble.Mumble.startTalking"))
hl.bind("mouse:276", hl.dsp.exec_cmd("gdbus call --session --dest net.sourceforge.mumble.mumble --object-path / --method net.sourceforge.mumble.Mumble.stopTalking"), { release = true })

hl.window_rule({
    name = "steam-workspace-1",
    workspace = "1 silent",
    match = {
        class = "Steam",
    },
})

hl.window_rule({
    name = "firefox-workspace-1",
    workspace = "1 silent",
    match = {
        class = "firefox",
    },
})

hl.window_rule({
    name = "discord-magic",
    workspace = "special:magic silent",
    float = true,
    match = {
        class = "discord",
    },
})

hl.exec_cmd("notify-send -u low -t 2000 'loaded'")
