local ui = require("ui")

---@class Timer
---@field is_running boolean
---@field remaining_time number
---@field work_duration number
---@field break_duration number
---@field mode "Work" | "Break"
---@field ui_active boolean
local Timer = {}

Timer.is_running = false
Timer.remaining_time = 0
Timer.mode = "Work"
Timer.ui_active = false

local function update_statusline()
	vim.cmd("redrawstatus")
end

function Timer:start()
	if self.is_running then
		vim.notify("Timer is already running", vim.log.levels.INFO, {})
		return
	end

	self.is_running = true
	self.remaining_time = self.work_duration
	self.mode = "Work"

	local timer = vim.loop.new_timer()
	timer:start(
		1000,
		1000,
		vim.schedule_wrap(function()
			if self.remaining_time > 0 then
				self.remaining_time = self.remaining_time - 1
				update_statusline()
			else
				if not self.ui_active then
					self.ui_active = true
					ui.RenderUI(function(confirmed)
						self.ui_active = false
						if confirmed then
							-- User confirmed, continue timer
							if self.mode == "Work" then
								self.mode = "Break"
								self.remaining_time = self.break_duration
								vim.notify("Break time!", vim.log.levels.INFO, {})
							else
								self.mode = "Work"
								self.remaining_time = self.work_duration
								vim.notify("Work time!", vim.log.levels.INFO, {})
							end
						else
							-- User denied, stop the timer
							self.is_running = false
							timer:stop()
							timer:close()
							vim.notify("Timer stopped.", vim.log.levels.INFO, {})
						end
					end)
				end
				-- Stop the timer if it's not running
				if not self.is_running then
					timer:stop()
					timer:close()
				end
			end
		end)
	)
end

function Timer:stop()
	if not self.is_running then
		vim.notify("Timer is not running", vim.log.levels.INFO, {})
		return
	end

	self.is_running = false
	self.mode = "Break"
	update_statusline()
end

return Timer
