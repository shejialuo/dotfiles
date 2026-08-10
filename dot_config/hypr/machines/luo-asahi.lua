-- luo-asahi
local mod = "SUPER"
local brightness_control = "~/.config/hypr/brightness_control.sh"
local keyboard_brightness_control = "~/.config/hypr/keyboard_brightness_control.sh"

------------------------------------------------------------
--- Basic configuration
------------------------------------------------------------

require("monitors")

hl.device({
  name = "apple-spi-keyboard",
  kb_options = "altwin:swap_alt_win",
})

hl.device({
  name = "apple-spi-trackpad",
  natural_scroll = true,
})

------------------------------------------------------------
--- End
------------------------------------------------------------



------------------------------------------------------------
--- Autostart applications
------------------------------------------------------------

hl.on("hyprland.start", function()
  hl.exec_cmd(
    "hyprdynamicmonitors run --disable-power-events --enable-lid-events"
  )
end)

------------------------------------------------------------
--- Start applications
------------------------------------------------------------

hl.bind(
  mod .. " + f2",
  hl.dsp.exec_cmd("chromium-browser")
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd(brightness_control .. " down")
)
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd(brightness_control .. " up")
)

hl.bind(
    mod .. " + SHIFT + z",
    hl.dsp.exec_cmd(keyboard_brightness_control .. " down")
)
hl.bind(
    mod .. " + SHIFT + x",
    hl.dsp.exec_cmd(keyboard_brightness_control .. " up")
)

------------------------------------------------------------
--- End
------------------------------------------------------------



------------------------------------------------------------
-- Window rules
------------------------------------------------------------

hl.window_rule({
  match = {
    class = "chromium-browser",
  },
  opacity = "1.0 override 1.0 override",
})

hl.window_rule({
  match = {
    class = "mpv",
   },
  opacity = "1.0 override 1.0 override",
})

hl.window_rule({
  match = {
    class = "org.pwmt.zathura",
  },
  opacity = "1.0 override 1.0 override",
})

------------------------------------------------------------
--- End
------------------------------------------------------------
