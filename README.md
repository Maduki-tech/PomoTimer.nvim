# PomoTimer.nvim

A Pomodoro timer for Neovim in the Statusline.

## Installation

```lua
{
    "Maduki-tech/PomoTimer.nvim",
    opts = {},
}
```

## Roadmap

- [ ] Customizable Break Time
- [ ] Customizable Work Time
- [ ] Make work with other Statusline Tools
- [ ] Notifications

## Usage

Start the timer with `PomoTimer.start()` and stop it with `PomoTimer.stop()`.

## Configuration

### Heirline

```lua
local PomodoroComponent = {
provider = function()
  local pomo = require('PomoTimer').timer
  if pomo.is_running then
    return 'Pomodoro: ' .. pomo.mode .. ' ' .. pomo.remaining_time .. 's'
  end
end,
hl = { fg = colors.red, bg = colors.bg },
}
```

### View in Minutes and Seconds

```lua
local formatted_time = string.format('%02d:%02d', math.floor(pomo.remaining_time / 60), pomo.remaining_time % 60)
```
