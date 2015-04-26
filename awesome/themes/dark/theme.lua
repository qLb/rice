
                -- [    Pro Gotham theme for Awesome 3.5.5    ] --
                -- [              author: barwinco            ] --
                -- [      http://github.com/barwinco/pro      ] --

-- // based on gotham colorscheme by Andrea Leopardi (https://github.com/whatyouhide/vim-gotham)
-- // got the idea from Holo theme by Luke Bonham (https://github.com/copycat-killer)

-- patch for taglist: https://github.com/awesomeWM/awesome/pull/39

theme             = {}
theme.icons       = os.getenv("HOME") .. "/.config/awesome/themes/dark/icons/"
theme.panel       = "#121920"
theme.font        = "Termsyn 10"

theme.fg_normal   = "#00D1A2"
theme.fg_focus    = "#00D1A2"
theme.fg_urgent   = "#00D1A2"
theme.fg_minimize = "#7a7a7a"

theme.bg_normal   = "#191919"
theme.bg_focus    = "#262626"
theme.bg_urgent   = "#3F3F3F70"
theme.bg_minimize = "#121212"

theme.wibox_height = 20

theme.useless_gap_width = 20

theme.awesome_icon = theme.icons .. "icon.png"

theme.clockgf    = "#99d1ce"

-- | Borders | --

theme.border_width  = 0
theme.border_normal = "#00272B00"
theme.border_focus  = "#00272B00"
theme.border_marked = "#00272B00"

-- | Menu | --

theme.menu_height = 18
theme.menu_width  = 160

-- | Layout | --

theme.layout_floating   = theme.icons .. "/panel/layouts/floating.png"
theme.layout_tile       = theme.icons .. "/panel/layouts/tile.png"
theme.layout_tileleft   = theme.icons .. "/panel/layouts/tileleft.png"
theme.layout_tilebottom = theme.icons .. "/panel/layouts/tilebottom.png"
theme.layout_tiletop    = theme.icons .. "/panel/layouts/tiletop.png"

-- | Taglist | --

theme.taglist_bg_empty    = "#191919"
theme.taglist_bg_occupied = "#252525"
theme.taglist_bg_focus    = "#303030"
theme.taglist_bg_urgent   = "#3F3F3F70"
theme.taglist_fg_focus    = "#ffffff"

-- | Tasklist | --

theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_sticky               = ""
theme.tasklist_ontop                = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

-- | Widget | --

theme.widget_bg        = "#0a0f1400"

-- | MPD | --

theme.mpd_prev  = theme.icons .. "/panel/widgets/mpd/mpd_prev.png"
theme.mpd_nex   = theme.icons .. "/panel/widgets/mpd/mpd_next.png"
theme.mpd_stop  = theme.icons .. "/panel/widgets/mpd/mpd_stop.png"
theme.mpd_pause = theme.icons .. "/panel/widgets/mpd/mpd_pause.png"
theme.mpd_play  = theme.icons .. "/panel/widgets/mpd/mpd_play.png"
theme.mpd_sepr  = theme.icons .. "/panel/widgets/mpd/mpd_sepr.png"
theme.mpd_sepl  = theme.icons .. "/panel/widgets/mpd/mpd_sepl.png"

-- | Separators | --

theme.spr    = theme.icons .. "/panel/separators/spr.png"
theme.spr5px = theme.icons .. "/panel/separators/spr5px.png"

-- | Misc | --

theme.menu_submenu_icon = theme.icons .. "submenu.png"

return theme

