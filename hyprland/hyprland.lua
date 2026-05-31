-- Hyprland 0.55 Lua config — mirrors XMonad configuration
-- Modifier keys: ALT (mod1) = primary, SUPER (mod4) = secondary

local mod = "ALT"
local sup = "SUPER"

-- ── Monitors ─────────────────────────────────────────────────────────────────
-- X11 output names used as placeholders. After first launch run
-- `hyprctl monitors` and update the output names below.
-- Geometry from xsession initExtra:
--   nvidia-settings CurrentMetaMode="DP-0: +2160+840, HDMI-0: +0+0 {rotation=left}"
-- Both monitors are 3840x2160, scale=1.2 → logical 3200x1800 each.
-- HDMI-A-2 with transform=1 (portrait): logical 1800x3200.
-- DP-2 x-offset = 1800, y-offset = (3200-1800)/2 = 700 to center it vertically.
hl.monitor({ output = "HDMI-A-2", mode = "3840x2160@60", position = "0x0",    scale = 1.2, transform = 1 })
hl.monitor({ output = "DP-2",    mode = "3840x2160@60", position = "1800x700", scale = 1.2 })

-- ── Nvidia env vars ───────────────────────────────────────────────────────────
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
-- Scale Steam's client UI to match monitor scale after force_zero_scaling
hl.env("STEAM_FORCE_DESKTOPUI_SCALING", "1.2")

-- ── Autostart ─────────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("mako")
end)

-- ── Config ────────────────────────────────────────────────────────────────────
hl.config({
  input = {
    follow_mouse = 1,
    sensitivity = 0,
  },

  general = {
    gaps_in = 5,
    gaps_out = 5,
    border_size = 4,
    col = {
      active_border = "rgba(458588ff)",
      inactive_border = "rgba(1d2021ff)",
    },
    layout = "master",
  },

  decoration = {
    rounding = 0,
    shadow = { enabled = false },
    blur = { enabled = false },
  },

  animations = {
    enabled = false,
  },

  master = {
    mfact = 0.5,
    new_status = "slave",
    orientation = "left",
  },

  misc = {
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
  },

  xwayland = {
    enabled = true,
    -- Render at native resolution so Hyprland doesn't upscale XWayland output.
    -- Without this, scale=1.2 causes compositor upscaling → blurry fonts.
    force_zero_scaling = true,
  },
})

-- ── Workspace rules ───────────────────────────────────────────────────────────
hl.workspace_rule({ workspace = "1", default_name = "1:web" })
hl.workspace_rule({ workspace = "2", default_name = "2:email" })
hl.workspace_rule({ workspace = "3", default_name = "3:code" })

-- ── Window rules ──────────────────────────────────────────────────────────────
hl.window_rule({ name = "float-mplayer", match = { class = "^MPlayer$" }, float = true })
hl.window_rule({ name = "float-steam", match = { class = "^steam$", title = "^Steam$" }, float = true })

-- ── Keybindings ───────────────────────────────────────────────────────────────

-- Terminal (mod+Shift+Return)
hl.bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd("alacritty"))

-- Window management
hl.bind(mod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = 1 }))

-- Layout cycling (left→top→right→bottom, approximates Tall|Mirror|Grid|Full)
hl.bind(mod .. " + Space", hl.dsp.layout("orientationnext"))
hl.bind(mod .. " + SHIFT + Space", hl.dsp.layout("orientationleft"))

-- Master layout operations
hl.bind(mod .. " + Return", hl.dsp.layout("swapwithmaster"))
hl.bind(mod .. " + H", hl.dsp.layout("mfact -0.05"))
hl.bind(mod .. " + L", hl.dsp.layout("mfact +0.05"))
hl.bind(mod .. " + comma", hl.dsp.layout("addmaster"))
hl.bind(mod .. " + period", hl.dsp.layout("removemaster"))

-- Cycle windows in workspace (mirrors mod+j/k stack navigation)
hl.bind(mod .. " + J", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mod .. " + K", hl.dsp.window.cycle_next({ next = false }))

-- Swap windows (mirrors mod+Shift+j/k)
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))

-- 2D navigation (Super key, mirrors XMonad Navigation2D)
hl.bind(sup .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(sup .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(sup .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(sup .. " + J", hl.dsp.focus({ direction = "down" }))

-- 2D window swapping
hl.bind(sup .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(sup .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(sup .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(sup .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))

-- Monitor focus (mod+w/r = prevScreen/nextScreen)
hl.bind(mod .. " + W", hl.dsp.focus({ monitor = "l" }))
hl.bind(mod .. " + R", hl.dsp.focus({ monitor = "r" }))

-- Move window to other monitor (mod+Shift+w/r)
hl.bind(mod .. " + SHIFT + W", hl.dsp.window.move({ monitor = "HDMI-A-2" }))
hl.bind(mod .. " + SHIFT + R", hl.dsp.window.move({ monitor = "DP-2" }))

-- Workspace navigation
hl.bind(mod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mod .. " + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + left", hl.dsp.focus({ workspace = "e-1" }))

-- Empty workspace (mod+n = view empty, mod+Shift+n = send window there silently)
hl.bind(mod .. " + N", hl.dsp.focus({ workspace = "empty" }))
hl.bind(mod .. " + SHIFT + N", hl.dsp.window.move({ workspace = "empty", follow = false }))

-- Launchers (mod+p/Shift+p)
hl.bind(mod .. " + P", hl.dsp.exec_cmd("rofi -show run"))
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("rofi -show window"))

-- Workspace selector via rofi (mod+v, approximates selectWorkspace prompt)
hl.bind(
  mod .. " + V",
  hl.dsp.exec_cmd(
    'bash -c \'ws=$(seq 1 12 | rofi -dmenu -p "Workspace:"); [ -n "$ws" ] && hyprctl dispatch workspace "$ws"\''
  )
)

-- Move window to workspace via rofi (mod+b, approximates W.shift via prompt)
hl.bind(
  mod .. " + B",
  hl.dsp.exec_cmd(
    'bash -c \'ws=$(seq 1 12 | rofi -dmenu -p "Move to:"); [ -n "$ws" ] && hyprctl dispatch movetoworkspace "$ws"\''
  )
)

-- Banish cursor to top-left corner (mod+o)
hl.bind(mod .. " + O", hl.dsp.cursor.move_to_corner({ corner = 0 }))

-- Session
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mod .. " + Q", hl.dsp.exec_cmd("hyprctl reload"))

-- Lock screen (Super+Shift+z)
hl.bind(sup .. " + SHIFT + Z", hl.dsp.exec_cmd("hyprlock"))

-- App shortcuts
hl.bind(sup .. " + F1", hl.dsp.exec_cmd("firefox"))
hl.bind(sup .. " + F3", hl.dsp.exec_cmd("nautilus"))

-- Audio (PipeWire via wpctl)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 2%-"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 2%+"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("increment_brightness"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("decrement_brightness"), { locked = true })

-- F-key workspaces (mod+F1→ws11, mod+F2→ws12)
hl.bind(mod .. " + F1", hl.dsp.focus({ workspace = 11 }))
hl.bind(mod .. " + F2", hl.dsp.focus({ workspace = 12 }))
hl.bind(mod .. " + SHIFT + F1", hl.dsp.window.move({ workspace = 11, follow = false }))
hl.bind(mod .. " + SHIFT + F2", hl.dsp.window.move({ workspace = 12, follow = false }))

-- Workspace number row (mod+1..9 = ws1..9, mod+0 = ws10)
-- mod+Shift+N sends window to workspace N without following (mirrors W.shift)
for i = 1, 10 do
  local key = i % 10
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Mouse bindings (mirrors XMonad myMouseBindings)
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:274", hl.dsp.window.resize(), { mouse = true })
