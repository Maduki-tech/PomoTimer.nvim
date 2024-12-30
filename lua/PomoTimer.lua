local timer = require("timer")
local M = {}

M.setup = function(opts)
	vim.api.nvim_create_user_command("PomoTimer", function(opts)
		vim.notify("Hello, world!")
	end, {})

	vim.api.nvim_create_user_command("PomoStart", function()
		timer:start()
	end, {})

	vim.api.nvim_create_user_command("PomoStop", function()
		timer:stop()
	end, {})
end

M.timer = timer

return M
