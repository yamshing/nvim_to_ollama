local NvimToOllama = {}
NvimToOllama.__index = NvimToOllama

function _G.close_both_floats()
	for _, win in ipairs({ _G.float_win_left, _G.float_win_right }) do
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
end
 
	
function NvimToOllama.new()
  local self = setmetatable({}, NvimToOllama)
  self.value = 0
	self.m_user_input = ""
  return self
end
 
function NvimToOllama:test()
	 --print(self.m_user_input)
	 self:hoge()
end
 
function NvimToOllama:hoge()
	print("hoge called") 
end
 
function NvimToOllama:diff_user_input_and_lines(lines)
	 
  local input_lines = vim.split(self.m_user_input or "", "\n")
	local tmp1 = vim.fn.tempname()
  local tmp2 = vim.fn.tempname()
	vim.fn.writefile(input_lines, tmp1)
	 
	--for i, v in ipairs(lines) do
	--	print(i, vim.inspect(v), type(v))
	--end
	
	vim.fn.writefile(lines, tmp2)
	local output = vim.fn.system({'diff', '-u', tmp1, tmp2})
	local splitted = vim.split(output, '\n')
	--vim.print(output)
	return splitted
end

function NvimToOllama:set_diff_lines(diff_lines)
  local left_lines = {}
  local right_lines = {}
  local left_hl = {}
  local right_hl = {}

  for li, line in ipairs(diff_lines) do
    local prefix = line:sub(1, 1)
    local content = line:sub(2)
    --vim.print("li", li, line)
    if line:match("^%-%-%- /.+") or line:match("^%+%+%+ /.+") then
      goto continue
    end
    if prefix == "-" then
      table.insert(left_lines, content)
      table.insert(left_hl, "DiffDelete")
    elseif prefix == "+" then
      table.insert(right_lines, content)
      table.insert(right_hl, "DiffAdd")
    elseif prefix == " " or prefix == "" then
      table.insert(left_lines, content)
      table.insert(right_lines, content)
      table.insert(left_hl, false)
      table.insert(right_hl, false)
    end
    ::continue::
  end

  if #left_lines == 0 then
    table.insert(left_lines, "No differences found.")
    table.insert(right_lines, "No differences found.")
  end

  return left_lines, right_lines, left_hl, right_hl
end
 
function NvimToOllama:show_diff_floating_window(diff_lines)

	local buf_left = vim.api.nvim_create_buf(false, true)
  local buf_right = vim.api.nvim_create_buf(false, true)

  local left_lines, right_lines, left_hl, right_hl = self:set_diff_lines(diff_lines)

  vim.api.nvim_buf_set_lines(buf_left, 0, -1, false, left_lines)
  vim.api.nvim_buf_set_lines(buf_right, 0, -1, false, right_lines)

	--vim.print(left_hl)
  -- Add highlights
  for i, hl in ipairs(left_hl) do
    if hl then
			--vim.print("left buf",i - 1,hl)
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


function NvimToOllama:show_reply_to_floating_win(reply)
  reply = reply:gsub("%z", "")
	
  local lines = vim.split(reply or "", "\n")
	 
  if lines[1]:match("^%s*```") then
    table.remove(lines, 1)
  end
  if lines[#lines]:match("^%s*```%s*$") then
    table.remove(lines, #lines)
  end
	--for i, line in ipairs(lines) do
	--	print(string.format("lines[%d] = %s", i, vim.inspect(line)))
	--end
	--print(self.m_user_input)
	--print(lines)
	 
	local diff = self:diff_user_input_and_lines(lines)
	--print('diff ------------------------------')
	--print(diff)
	 
  self:show_diff_floating_window(diff)
end
function NvimToOllama:get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
	vim.print(start_pos)
	vim.print(end_pos)

  -- Check if no visual selection is made
  if (start_pos[2] == end_pos[2] and start_pos[3] == end_pos[3]) or (start_pos[2] ~= end_pos[2] and start_pos[3] == 1 and end_pos[3] == 1) then
    print("No visual selection detected.")
    return ""
  end

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
 
function NvimToOllama:process_chat_api_request(user_text)
  local payload = {
    model = "gemma2",
    messages = {
      { role = "system", content = "You are a test assistant." },
      { role = "user", content = user_text },
    }
  }

  local json_payload = vim.fn.json_encode(payload)

  local cmd = {
    "curl", "-s",
    --"http://localhost:11434/v1/chat/completions",
    "http://localhost:11434/v1/chat/completions",
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
 
function NvimToOllama:send_selection_to_chat(order)
	--local order = 'refactor this code by changing i to index'
	local head = '< |User| > ' .. order .. '\n'
	local foot = '\n<|Assistant|>'
	 
  local user_text = self:get_visual_selection()

  -- if user_text == "" then
  --   print("No selection found.")
  --   return
  -- end
  self.m_user_input = user_text
	user_text = head .. user_text
	user_text = user_text .. foot
	 
  -- Call the new function
  local reply = self:process_chat_api_request(user_text)
  if not reply then return end
	--print('reply------------------------------')
	--print(reply)

  -- append the reply to the log file
  local log_file = vim.fn.expand("~/.cache/nvim/ollama.log")
  local log_entry = os.date("%Y-%m-%d %H:%M:%S") .. " - " .. reply .. "\n"
  vim.fn.writefile( vim.split(log_entry,"\n") , log_file, "a")

  self:show_reply_to_floating_win(reply)
end

return NvimToOllama



