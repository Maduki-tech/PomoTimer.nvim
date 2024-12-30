--- UI for PomoTimer
local timer = require("timer")

local M = {}

function M.RenderUI()
	local width = math.floor(vim.o.columns * (40 / 100))
	local height = math.floor(vim.o.lines * (40 / 100))
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
		"Time is up!",
		"",
		"Press <Enter> to confirm",
		"",
		"Press <Esc> to cancel",
	})

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		title = "PomoTimer",
		style = "minimal",
		border = "rounded",
	})

	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<CR>",
		":lua CloseUi(" .. buf .. "," .. win .. "," .. 1 .. ")<CR>",
		{ noremap = true, silent = true }
	)

	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<Esc>",
		":lua CloseUi(" .. buf .. "," .. win .. "," .. 0 .. ")<CR>",
		{ noremap = true, silent = true }
	)

	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end

function CloseUi(buf, win, continue)
	vim.api.nvim_win_close(win, true)
	vim.api.nvim_buf_delete(buf, { force = true })

	if continue == 1 then
		timer:start()
	else
		timer:stop()
	end
end

vim.keymap.set("n", "<leader>t", M.RenderUI, { silent = true })

return M
