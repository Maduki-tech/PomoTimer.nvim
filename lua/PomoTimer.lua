local timer = require("timer")
local M = {}

---@class TimerOptions
---@field work_duration number
---@field break_duration number

---@param opts TimerOptions
function M.setup(opts)
	opts = opts or {}

	---@type TimerOptions
	local defaults = {
		work_duration = 25,
		break_duration = 5,
	}

	opts = vim.tbl_deep_extend("force", defaults, opts)

	timer.work_duration = opts.work_duration * 60
	timer.break_duration = opts.break_duration * 60

	vim.api.nvim_create_user_command("PomoStart", function()
		timer:start()
	end, {})

	vim.api.nvim_create_user_command("PomoStop", function()
		timer:stop()
	end, {})
end

M.timer = timer

return M
