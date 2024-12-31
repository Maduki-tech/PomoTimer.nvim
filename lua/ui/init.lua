--- UI for PomoTimer
local M = {}

local FloatingWindow = {
	win_id = nil,
	buf_id = nil,
}

function M.RenderUI(callback)
	-- Calculate dimensions
	local width = math.floor(vim.o.columns * (40 / 100))
	local height = math.floor(vim.o.lines * (20 / 100))
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)
	vim.print("Opening UI")

	-- Create a new buffer
	FloatingWindow.buf_id = vim.api.nvim_create_buf(false, true)
	-- Open a floating window
	FloatingWindow.win_id = vim.api.nvim_open_win(FloatingWindow.buf_id, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	})

	-- Set buffer content
	vim.api.nvim_buf_set_lines(FloatingWindow.buf_id, 0, -1, false, {
		"Session Ended!",
		"",
		"Press [y] to confirm and continue.",
		"Press [n] to stop the timer.",
	})

	vim.api.nvim_buf_set_keymap(FloatingWindow.buf_id, "n", "y", ":lua CloseUI()<CR>", {
		noremap = true,
		callback = function()
			CloseUI()
			if callback then
				callback(true)
			end
		end,
	})

	vim.api.nvim_buf_set_keymap(FloatingWindow.buf_id, "n", "n", ":lua CloseUI()<CR>", {
		noremap = true,
		callback = function()
			CloseUI()
			if callback then
				callback(false)
			end
		end,
	})
end

function CloseUI()
	if FloatingWindow.win_id and vim.api.nvim_win_is_valid(FloatingWindow.win_id) then
		vim.api.nvim_win_close(FloatingWindow.win_id, true)
		vim.api.nvim_buf_delete(FloatingWindow.buf_id, { force = true })
		FloatingWindow.win_id = nil
		FloatingWindow.buf_id = nil
	end
	vim.print("Closed UI")
end

vim.keymap.set("n", "<leader>t", M.RenderUI, {})

return M
