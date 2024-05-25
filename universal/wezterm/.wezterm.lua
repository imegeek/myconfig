-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

local GLYPH_SEMI_CIRCLE_LEFT = ""
-- local GLYPH_SEMI_CIRCLE_LEFT = utf8.char(0xe0b6)
local GLYPH_SEMI_CIRCLE_RIGHT = ""
-- local GLYPH_SEMI_CIRCLE_RIGHT = utf8.char(0xe0b4)

-- Spawn Windows Shell
-- config.default_prog = { 'powershell'}
-- config.default_prog = { 'cmd'}

-- Spawn Posix Shell
-- config.default_prog = { 'bash', '-l'}
-- config.default_prog = { 'zsh', '-l'}

-- For example, changing the color scheme:
config.color_scheme = 'OneDark (base16)'

-- The default text color
config.colors = {
  foreground = 'white'
}

config.font = wezterm.font_with_fallback({
  { family = "DejaVuSansM Nerd Font Mono"},
})

-- Launcher Menu
config.launch_menu = {
  {
    label = "New Window (PowerShell)",
    args = { 'powershell' },
  },
  {
    label = "New Window (CMD)",
    args = {"cmd"},
  }
}

-- Keys
config.keys = {
  -- { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
  { key = 'Space', mods = 'CTRL', action = wezterm.action.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' }, },
}

-- config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.8
config.win32_system_backdrop = 'Acrylic'
-- config.window_close_confirmation = 'AlwaysPrompt'
config.window_decorations = "RESIZE"
config.initial_rows = 32
config.initial_cols = 120

config.scrollback_lines = 3000
config.default_workspace = "home"

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5
}

-- window
config.adjust_window_size_when_changing_font_size = false
config.integrated_title_button_color = "auto"
config.integrated_title_button_alignment = "Left"
config.window_padding = {
      left = 5,
      right = 0,
      top = 5,
      bottom = 5,
    }

function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local __cells__ = {}

local _push = function(bg, fg, attribute, text)
  table.insert(__cells__, { Background = { Color = bg } })
  table.insert(__cells__, { Foreground = { Color = fg } })
  table.insert(__cells__, { Attribute = attribute })
  table.insert(__cells__, { Text = text })
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    __cells__ = {}
    local bg
    local fg 
    local pane = tab.active_pane
    local title = basename(pane.foreground_process_name):gsub("%..*$", "")

    if tab.is_active then
      bg = "#03c1f4"
      fg = "#0F2536"
    else
      bg = "#404040"
      fg = "#fff"
    end

      local has_unseen_output = false
      for _, pane in ipairs(tab.panes) do
         if pane.has_unseen_output then
            has_unseen_output = true
            break
         end
      end

    return {
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = ' ' .. title .. ' ' },

    }
  end
)

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_max_width = 25
config.status_update_interval = 1000
config.show_tab_index_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true
wezterm.on("update-status", function(window, pane)

  -- Workspace name
  local stat = window:active_workspace()
  local stat_color = "#f7768e"
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = "#7dcfff"
  end
  if window:leader_is_active() then
    stat = "LDR"
    stat_color = "#bb9af7"
  end

  local basename = function(s)
    -- Nothing a little regex can't fix
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end

  -- Current working directory
  local cwd = pane:get_current_working_dir().file_path

  -- Current command
  local cmd = pane:get_foreground_process_name()
  -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
  cmd = cmd and basename(cmd):gsub("%..*$", "")
 or ""

  -- Time
  local time = wezterm.strftime("%H:%M")

  -- Battery
  local bat = ''
  local battery_icons = { '󰁺', '󰁻', '󰁼', '󰁽', '󰁾', '󰁿', '󰂀', '󰂁', '󰂂', '󰁹' }
  local battery_icon = ''
  local bat_color = ''

  for _, b in ipairs(wezterm.battery_info()) do
    -- local idx = math.clamp(math.round(b.state_of_charge * 10), 1, 10)
    bat = string.format('%.0f%%', b.state_of_charge * 100)
    local percent = tonumber(bat:sub(1, -2))
    local idx = math.floor(percent / 10)

    if b.state == 'Charging' then
       battery_icon = "󰂄"
       bat_color = "#afff96"
    else
       battery_icon = battery_icons[idx]
       if percent > 30 then
          bat_color = "#6AA1DA"
       else
          bat_color = "#ff8522"
       end
    end
  end

  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format({
    { Background = { Color = "#505050" } },
    -- { Foreground = { Color = "#03c1f4" } },
    { Text = " ".. wezterm.nerdfonts.dev_terminal_badge .. " " },
  }))

  -- Right status
  window:set_right_status(wezterm.format({
    -- Wezterm has a built-in nerd fonts
    -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html

    { Foreground = { Color = "#8BC455" } },
    { Text = wezterm.nerdfonts.fa_user },
    "ResetAttributes",
    { Text = " " .. os.getenv("USERNAME") },
    { Text = " " .. wezterm.nerdfonts.indent_line .. " " },

    { Foreground = { Color = "#4ab4ff" } },
    { Text = wezterm.nerdfonts.md_clipboard_pulse},
    "ResetAttributes",
    { Text = " " .. cmd },

    { Text = " " .. wezterm.nerdfonts.indent_line .. " " },

    { Foreground = { Color = "#6EBEDF" } }, 
    { Text = wezterm.nerdfonts.md_clock },
    "ResetAttributes",
    { Text = " " .. time },

    { Text = " " .. wezterm.nerdfonts.indent_line .. " " },

    { Foreground = { Color = bat_color } },
    { Text = battery_icon },
    "ResetAttributes",
    { Text =  " " .. bat},

    { Text = " "},

  }))
end)

return config
