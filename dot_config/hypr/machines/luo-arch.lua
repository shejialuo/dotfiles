-- luo-arch
local mod = "SUPER"

------------------------------------------------------------
--- Monitor
------------------------------------------------------------

hl.monitor({
    output = "DP-1",
    mode = "3840x2160@144",
    position = "0x0",
    scale = 2,
})

------------------------------------------------------------
--- End
------------------------------------------------------------



------------------------------------------------------------
--- Autostart applications
------------------------------------------------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("easyeffects --service-mode --hide-window")
end)

------------------------------------------------------------
--- Start applications
------------------------------------------------------------

hl.bind(
  mod .. " + f2",
  hl.dsp.exec_cmd("chromium")
)

hl.bind(
  mod .. " + f4",
  hl.dsp.exec_cmd("spotify")
)

------------------------------------------------------------
--- End
------------------------------------------------------------



------------------------------------------------------------
--- Spotify control
------------------------------------------------------------

local spotify_dbus =
  "dbus-send --print-reply " ..
  "--dest=org.mpris.MediaPlayer2.spotify " ..
  "/org/mpris/MediaPlayer2 " ..
  "org.mpris.MediaPlayer2.Player."

hl.bind(
  mod .. " + CTRL + up",
  hl.dsp.exec_cmd(spotify_dbus .. "PlayPause")
)

hl.bind(
  mod .. " + CTRL + left",
  hl.dsp.exec_cmd(spotify_dbus .. "Previous")
)

hl.bind(
  mod .. " + CTRL + right",
  hl.dsp.exec_cmd(spotify_dbus .. "Next")
)

------------------------------------------------------------
--- End
------------------------------------------------------------



------------------------------------------------------------
--- Window rules
------------------------------------------------------------

hl.window_rule({
  match = {
    class = "chromium",
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
