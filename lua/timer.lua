---@class Timer
---@field is_running boolean
---@field remaining_time number
---@field work_duration number
---@field break_duration number
---@field mode string
local Timer = {}

Timer.is_running = false
Timer.remaining_time = 0
Timer.work_duration = 25 * 60
Timer.break_duration = 5 * 60
Timer.mode = "work"

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
	self.mode = "work"

	local timer = vim.loop.new_timer()
	timer:start(
		1000,
		1000,
		vim.schedule_wrap(function()
			if self.remaining_time > 0 then
				self.remaining_time = self.remaining_time - 1
				update_statusline()
			else
				if self.mode == "work" then
					self.mode = "break"
					self.remaining_time = self.break_duration
					vim.notify("Break time!", vim.log.levels.INFO, {})
				else
					self.mode = "work"
					self.remaining_time = self.work_duration
					vim.notify("Work time!", vim.log.levels.INFO, {})
				end
				update_statusline()
			end
			if not self.is_running then
				timer:stop()
				timer:close()
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
	self.mode = "break"
	update_statusline()
end

return Timer
