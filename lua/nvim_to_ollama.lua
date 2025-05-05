local M = {}
local m_user_input = ""
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

local function diff_user_input_and_lines(user_input, lines)
	--local joined = table.concat(lines,"\n")
  local input_lines = vim.split(user_input or "", "\n")
	local tmp1 = vim.fn.tempname()
  local tmp2 = vim.fn.tempname()
	vim.fn.writefile(input_lines, tmp1)
	vim.fn.writefile(lines, tmp2)
	local output = vim.fn.system({'diff', '-u', tmp1, tmp2})
	local splitted = vim.split(output, '\n')
	--vim.print(output)
	return splitted
	 
  -- local diff = {}
	--  
  -- for i, line in ipairs(lines) do
  --   if line ~= input_lines[i] then
  --     table.insert(diff, { line_number = i, original = input_lines[i] or "", modified = line })
  --   end
  -- end

  -- return diff
end

function _G.close_both_floats()
	for _, win in ipairs({ _G.float_win_left, _G.float_win_right }) do
	  if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	  end
	end
  end
	 
local function show_diff_floating_window(diff_lines)

	 local buf_left = vim.api.nvim_create_buf(false, true)
  local buf_right = vim.api.nvim_create_buf(false, true)

  local left_lines = {}
  local right_lines = {}
  local left_hl = {}
  local right_hl = {}

  for li, line in ipairs(diff_lines) do
    local prefix = line:sub(1, 1)
    local content = line:sub(2)
		--vim.print("li",li, prefix)
    if prefix == "-" then
      table.insert(left_lines, content)
      table.insert(right_lines, "")
      table.insert(left_hl, "DiffDelete")  -- red
      table.insert(right_hl, false)
			vim.print("diffdel insert",li)
    elseif prefix == "+" then
      table.insert(left_lines, "")
      table.insert(right_lines, content)
      table.insert(left_hl, false)
      table.insert(right_hl, "DiffAdd")  -- green
    elseif prefix == " " or prefix == "" then
      table.insert(left_lines, content)
      table.insert(right_lines, content)
      table.insert(left_hl, false)
      table.insert(right_hl, false)
    end
  end

  if #left_lines == 0 then
    table.insert(left_lines, "No differences found.")
    table.insert(right_lines, "No differences found.")
  end

  vim.api.nvim_buf_set_lines(buf_left, 0, -1, false, left_lines)
  vim.api.nvim_buf_set_lines(buf_right, 0, -1, false, right_lines)

	vim.print(left_hl)
  -- Add highlights
  for i, hl in ipairs(left_hl) do
    if hl then
			vim.print("left buf",i - 1,hl)
      vim.api.nvim_buf_add_highlight(buf_left, -1, hl, i - 1, 0, -1)
    end
  end

  for i, hl in ipairs(right_hl) do
    if hl then
      vim.api.nvim_buf_add_highlight(buf_right, -1, hl, i - 1, 0, -1)
    end
  end

  local width = math.floor(vim.o.columns * 0.4)
  local height = math.floor(vim.o.lines * 0.4)
  local row = math.floor((vim.o.lines - height) / 2)
  local col_gap = math.floor((vim.o.columns - 2 * width) / 3)

  _G.float_win_left = vim.api.nvim_open_win(buf_left, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col_gap,
    style = "minimal",
    border = "rounded",
  })

  _G.float_win_right = vim.api.nvim_open_win(buf_right, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col_gap + width + col_gap,
    style = "minimal",
    border = "rounded",
  })
	--set keymaps for closing the windows
	vim.api.nvim_buf_set_keymap(buf_left, 'n', 'q', '<cmd>lua close_both_floats()<CR>', { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf_right, 'n', 'q', '<cmd>lua close_both_floats()<CR>', { noremap = true, silent = true })
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

  -- Compute diff with m_user_input
  local diff = diff_user_input_and_lines(m_user_input, lines)

  -- Show the diff in a floating window
  show_diff_floating_window(diff)

  -- Show the reply in a floating window
  --show_floating_window(lines)
end


local function process_chat_api_request(user_text)
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
    return nil
  end

  return response.choices[1].message.content
end

function M.send_selection_to_chat()
	local head = '< |User| > refactor this code by changing i to index and output just the code without explanation. Add ``` to show the language used:\n'
	local foot = '\n<|Assistant|>'
	 
  local user_text = get_visual_selection()

  if user_text == "" then
    print("No selection found.")
    return
  end
  m_user_input = user_text
	user_text = head .. user_text
	user_text = user_text .. foot
	 
  -- Call the new function
  local reply = process_chat_api_request(user_text)
  if not reply then return end

  show_reply_to_floating_win(reply)
end

M.show_reply_to_floating_win = show_reply_to_floating_win

return M


