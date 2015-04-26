local gears      = require("gears")
local awful      = require("awful")
awful.rules      = require("awful.rules")
                   require("awful.autofocus")
local wibox      = require("wibox")
local beautiful  = require("beautiful")
local vicious    = require("vicious")
local naughty    = require("naughty")
local lain       = require("lain")
local cyclefocus = require('cyclefocus')

local menubar = require("menubar")

-- | Theme | --

local theme = "dark"

beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/" .. theme .. "/theme.lua")

-- | Wallpaper | --

beautiful.wallpaper   = os.getenv("HOME") .. "/.config/awesome/wallpapers/kosaki.png"

-- | Error handling | --

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

-- | Fix's | --

-- Disable cursor animation:

local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
    oldspawn(s, false)
end

-- Java GUI's fix:

awful.util.spawn_with_shell("wmname LG3D")

-- | Variable definitions | --

local home   = os.getenv("HOME")
local exec   = function (s) oldspawn(s, false) end
local shexec = awful.util.spawn_with_shell

modkey        = "Mod4"
terminal      = "urxvt"
tmux          = "urxvt -e tmux"
termax        = "urxvt --geometry 1680x1034+0+22"
rootterm      = "sudo -i urxvt"
browser       = "chromium"
filemanager   = "pcmanfm"
configuration = termax .. ' -e "vim -O $HOME/.config/awesome/rc.lua $HOME/.config/awesome/themes/' ..theme.. '/theme.lua"'

-- | Table of layouts | --

local layouts =
{
--    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating
}

-- | Wallpaper | --

if beautiful.wallpaper then
    for s = 1, screen.count() do
        -- gears.wallpaper.tiled(beautiful.wallpaper, s)
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

-- | Tags | --

tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15" }, s, layouts[0])
    --GREEK: tags[s] = awful.tag({ "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ρ", "σ", "τ", "υ", "φ", "χ", "ψ", "ω" }, s, layouts[1])
end

-- | Menu | --

menu_main = {
  { "hibernate", "sudo pm-hibernate" },
  { "poweroff",  "sudo poweroff"     },
  { "restart",   awesome.restart     },
  { "reboot",    "sudo reboot"       },
  { "quit",      awesome.quit        }}

mainmenu = awful.menu({ items = {
  { " awesome",       menu_main   },
  { " file manager",  filemanager },
  { " root terminal", rootterm    },
  { " user terminal", terminal    },
  { " ssh celestial", terminal .. " -e \"ssh root@celestial.cf -p 8682\""},
  { " firefox", "firefox" },
  { " ncmpcpp", terminal .. " -e /home/celestial/scripts/mpc" },
  { " update mpd", terminal .. " -e /home/celestial/tag.sh" },
  { " quassel", "quasselclient" },
  { " brackets", "brackets" },
  { " sublime_text", "subl3" },
  { " shutdown", "sudo shutdown -h now"}}})

-- | Markup | --

markup = lain.util.markup

clockgf = beautiful.clockgf

-- | Widgets | --

spr = wibox.widget.imagebox()
spr:set_image(beautiful.spr)
spr5px = wibox.widget.imagebox()
spr5px:set_image(beautiful.spr5px)

widget_display = wibox.widget.imagebox()
widget_display:set_image(beautiful.widget_display)
widget_display_r = wibox.widget.imagebox()
widget_display_r:set_image(beautiful.widget_display_r)
widget_display_l = wibox.widget.imagebox()
widget_display_l:set_image(beautiful.widget_display_l)
widget_display_c = wibox.widget.imagebox()
widget_display_c:set_image(beautiful.widget_display_c)

-- | MPD | --

prev_icon = wibox.widget.imagebox()
prev_icon:set_image(beautiful.mpd_prev)
next_icon = wibox.widget.imagebox()
next_icon:set_image(beautiful.mpd_nex)
play_pause_icon = wibox.widget.imagebox()
play_pause_icon:set_image(beautiful.mpd_play)

musicwidget = wibox.widget.textbox()
vicious.register(musicwidget, vicious.widgets.mpd,
    function (mpdwidget, args)
        if args["{state}"] == "Stop" or args["{state}"] == "Pause" then 
            play_pause_icon:set_image(beautiful.mpd_play)
            return " - "
        else 
            play_pause_icon:set_image(beautiful.mpd_pause)
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 0.2)


musicwidget:buttons(awful.util.table.join(awful.button({ }, 1,
function () awful.util.spawn_with_shell(ncmpcpp) end)))
prev_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.util.spawn_with_shell("mpc prev || ncmpcpp prev")
end)))
next_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.util.spawn_with_shell("mpc next || ncmpcpp next")
end)))
play_pause_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.util.spawn_with_shell("mpc toggle || ncmpcpp toggle")
end)))

-- | CPU / TMP | --

-- Initialize widget
volwidget = wibox.widget.textbox()
volwidget:buttons(awful.util.table.join(
                 awful.button({ }, 3, function () awful.util.spawn("amixer -M set Master toggle", false) end),
                 awful.button({ }, 4, function () awful.util.spawn("amixer -M set Master 2%+", false) end),
                 awful.button({ }, 5, function () awful.util.spawn("amixer -M set Master 2%-", false) end)))
-- Register widget
vicious.register(volwidget, vicious.widgets.volume, "$2$1%", 0.1, "Master")

-- | Battery | --

-- Initialize widget
batwidget = wibox.widget.textbox()
-- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 2, "BAT1")

-- | Clock / Calendar | --

mytextclock    = awful.widget.textclock(markup(clockgf, " %H:%M "))
mytextcalendar = awful.widget.textclock(markup(clockgf, " %a %d %b"))

clockwidget = wibox.widget.background()
clockwidget:set_widget(mytextclock)
clockwidget:set_bg(beautiful.widget_bg)

local index = 1
local loop_widgets = { mytextclock, mytextcalendar }
local loop_widgets_icons = { beautiful.widget_clock, beautiful.widget_cal }

clockwidget:buttons(awful.util.table.join(awful.button({}, 1,
    function ()
        index = index % #loop_widgets + 1
        clockwidget:set_widget(loop_widgets[index])
        widget_clock:set_image(loop_widgets_icons[index])
    end)))

-- | Taglist | --

mytaglist         = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )

-- | Tasklist | --

mytasklist         = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

-- | PANEL | --
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mainmenu })

mywibox           = {}
mywiboxd          = {}
mypromptbox       = {}
mylayoutbox       = {}

for s = 1, screen.count() do
   
    mypromptbox[s] = awful.widget.prompt()
    
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    mywibox[s] = awful.wibox({ position = "top", screen = s, height = beautiful.wibox_height })
    mywiboxd[s] = awful.wibox({ position = "bottom", screen = s, height = beautiful.wibox_height })

    local left_layout_top = wibox.layout.fixed.horizontal()
    left_layout_top:add(mylauncher)

    local right_layout_top = wibox.layout.fixed.horizontal()
    right_layout_top:add(mylayoutbox[s])

    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])

    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then
        right_layout:add(mypromptbox[s])
        right_layout:add(wibox.widget.systray())
    end

    right_layout:add(spr5px)

    right_layout:add(musicwidget)

    right_layout:add(spr5px)

    right_layout:add(prev_icon)

    right_layout:add(spr)

    right_layout:add(play_pause_icon)

    right_layout:add(spr)

    right_layout:add(next_icon)

    right_layout:add(spr5px)

    right_layout:add(volwidget)

    right_layout:add(spr5px)

    right_layout:add(batwidget)

    right_layout:add(spr5px)

    right_layout:add(clockwidget)

    right_layout:add(spr5px)

    local layout_top = wibox.layout.align.horizontal()
    layout_top:set_left(left_layout_top)
    layout_top:set_middle(mytasklist[s])
    layout_top:set_right(right_layout_top)

    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    -- mywibox[s]:set_bg(beautiful.panel)
    mywibox[s]:set_widget(layout_top)

    -- mywiboxd[s]:set_bg(beautiful.panel)
    mywiboxd[s]:set_widget(layout)
end

-- | Mouse bindings | --

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mainmenu:toggle() end)
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
))

-- | Key bindings | --


globalkeys = awful.util.table.join(
    awful.key({ modkey }, "g", function () awful.util.spawn("xscreensaver-command -lock") end),
    awful.key({ modkey,           }, "w",      function () mainmenu:show() end),
    awful.key({ modkey, "Shift"   }, ".",      function () lain.util.useless_gaps_resize(5) end),
    awful.key({ modkey, "Shift"   }, ",",      function () lain.util.useless_gaps_resize(-5) end),
    awful.key({ modkey            }, "r",      function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end),
    -- awful.key({ modkey,         }, "Tab", function(c)
    --         cyclefocus.cycle(1, {modifier="Super_L"})
    -- end),
    -- awful.key({ modkey, "Shift" }, "Tab", function(c)
    --         cyclefocus.cycle(-1, {modifier="Super_L"})
    -- end),
    cyclefocus.key({ "Mod1", }, "Tab", 1, {
        cycle_filters = { cyclefocus.filters.same_screen, cyclefocus.filters.common_tag },
        keys = {'Tab', 'ISO_Left_Tab'}
    }),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),
    awful.key({ modkey,           }, "Return", function () exec(terminal) end),
    awful.key({ modkey, "Control" }, "Return", function () exec(rootterm) end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey }, "p", function() menubar.show() end),
       awful.key({ }, "XF86AudioRaiseVolume", function ()
       awful.util.spawn("amixer -M set Master 2%+", false) end),
   awful.key({ }, "XF86AudioLowerVolume", function ()
       awful.util.spawn("amixer -M set Master 2%-", false) end),
   awful.key({ }, "XF86AudioMute", function ()
       awful.util.spawn("amixer -M set Master toggle", false) end),
   awful.key({}, "Print", function () awful.util.spawn("shutter -f") end)
    -- awful.key({ modkey            }, "a",      function () shexec(configuration) end),
)

local wa = screen[mouse.screen].workarea
ww = wa.width
wh = wa.height
ph = 16 -- (panel height)

clientkeys = awful.util.table.join(
    awful.key({ modkey            }, "Next",     function () awful.client.moveresize( 20,  20, -40, -40) end),
    awful.key({ modkey            }, "Prior",    function () awful.client.moveresize(-20, -20,  40,  40) end),
    awful.key({ modkey            }, "Down",     function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ modkey            }, "Up",       function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ modkey            }, "Left",     function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ modkey            }, "Right",    function () awful.client.moveresize( 20,   0,   0,   0) end),
    awful.key({ modkey, "Control" }, "KP_Left",  function (c) c:geometry( { width = ww / 2, height = wh, x = 0, y = ph } ) end),
    awful.key({ modkey, "Control" }, "KP_Right", function (c) c:geometry( { width = ww / 2, height = wh, x = ww / 2, y = ph } ) end),
    awful.key({ modkey, "Control" }, "KP_Up",    function (c) c:geometry( { width = ww, height = wh / 2, x = 0, y = ph } ) end),
    awful.key({ modkey, "Control" }, "KP_Down",  function (c) c:geometry( { width = ww, height = wh / 2, x = 0, y = wh / 2 + ph } ) end),
    awful.key({ modkey, "Control" }, "KP_Prior", function (c) c:geometry( { width = ww / 2, height = wh / 2, x = ww / 2, y = ph } ) end),
    awful.key({ modkey, "Control" }, "KP_Next",  function (c) c:geometry( { width = ww / 2, height = wh / 2, x = ww / 2, y = wh / 2 + ph } ) end),
    awful.key({ modkey, "Control" }, "KP_Home",  function (c) c:geometry( { width = ww / 2, height = wh / 2, x = 0, y = ph } ) end),
    awful.key({ modkey, "Control" }, "KP_End",   function (c) c:geometry( { width = ww / 2, height = wh / 2, x = 0, y = wh / 2 + ph } ) end),
    awful.key({ modkey, "Control" }, "KP_Begin", function (c) c:geometry( { width = ww, height = wh, x = 0, y = ph } ) end),
    awful.key({ modkey,           }, "f",        function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",        function (c) c:kill() end),
    awful.key({ modkey,           }, "n",
        function (c)
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

awful.menu.menu_keys = {
    up    = { "k", "Up" },
    down  = { "j", "Down" },
    exec  = { "l", "Return", "Space" },
    enter = { "l", "Right" },
    back  = { "h", "Left" },
    close = { "q", "Escape" }
}

root.keys(globalkeys)

-- | Rules | --

awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     -- size_hints_honor = false,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "gcolor2" },
      properties = { floating = true } },
    { rule = { class = "xmag" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
}

-- | Signals | --

client.connect_signal("manage", function (c, startup)
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- | run_once | --

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- | Autostart | --

-- os.execute("pkill compton")
-- run_once("compton")
-- run_once("parcellite")

