local M = {}

function M.send_line_to_chat()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local user_line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]

	local payload = {
		model = "qwen2.5-coder",
		messages = {
			{
				role = "system",
				content = "You are a test assistant."
			},
			{
				role = "user",
				content = user_line
			}
		}
	}

	local json_payload = vim.fn.json_encode(payload)

	local cmd = {
		"curl", "-s",
		"http://localhost:11434/v1/chat/completions",
		"-H", "Content-Type: application/json",
		"-d", json_payload
	}

	local result = vim.fn.system(cmd)

	local ok, response = pcall(vim.fn.json_decode, result)
	if not ok or not response or not response.choices or not response.choices[1] then
		print("Error from chat API")
		return
	end

	local reply = response.choices[1].message.content
	local lines = vim.split(reply, "\n")

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local width = math.max(60, math.floor(vim.o.columns * 0.6))
	local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.5))
	local row_pos = math.floor((vim.o.lines - height) / 2)
	local col_pos = math.floor((vim.o.columns - width) / 2)

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row_pos,
		col = col_pos,
		style = "minimal",
		border = "rounded",
	})
end

return M

