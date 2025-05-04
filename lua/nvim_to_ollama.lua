local M = {}

-- Utility: Get visual selection
local function get_visual_selection()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	local start_line = start_pos[2]
	local start_col = start_pos[3]
	local end_line = end_pos[2]
	local end_col = end_pos[3]

	if start_line > end_line or (start_line == end_line and start_col > end_col) then
		start_line, end_line = end_line, start_line
		start_col, end_col = end_col, start_col
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	if #lines == 0 then return "" end

	if #lines == 1 then
		lines[1] = string.sub(lines[1], start_col, end_col)
	else
		lines[1] = string.sub(lines[1], start_col)
		lines[#lines] = string.sub(lines[#lines], 1, end_col)
	end

	return table.concat(lines, "\n")
end
local function show_floating_window(text_lines)
  local buf = vim.api.nvim_create_buf(false, true) -- scratch, no listed

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, text_lines)

  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.4)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })
end

local function show_reply_to_floating_win(reply)
  -- Split into lines
  local lines = vim.split(reply or "", "\n")

  -- Remove first line if it's a code fence
  if lines[1]:match("^```") then
    table.remove(lines, 1)
  end

  -- Remove last line if it's a closing ```
  if lines[#lines]:match("^```%s*$") then
    table.remove(lines, #lines)
  end

  -- Show in floating window
  show_floating_window(lines)
end

function M.send_selection_to_chat()
  local user_text = get_visual_selection()

  if user_text == "" then
    print("No selection found.")
    return
  end

  local payload = {
    model = "qwen2.5-coder",
    messages = {
      { role = "system", content = "You are a test assistant." },
      { role = "user", content = user_text },
    }
  }

  local json_payload = vim.fn.json_encode(payload)

  local cmd = {
    "curl", "-s",
    --"http://localhost:11434/v1/chat/completions",
    "http://localhost:8888/v1/chat/completions",
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
	vim.print(response)
	vim.print(reply)
	--vim.print(reply)

  -- Call the new function
  --show_reply_to_floating_win(reply)
end

return M


