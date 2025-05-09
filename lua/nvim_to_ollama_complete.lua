local NvimToOllama = require("nvim_to_ollama")

local NvimToOllamaComplete = {}
NvimToOllamaComplete.__index = NvimToOllamaComplete

function NvimToOllamaComplete.new()
  local self = setmetatable({}, NvimToOllamaComplete)
	 
  return self
end
 
function NvimToOllamaComplete:insert_test(opt)
	vim.print("insert_test")
  --vim.api.nvim_buf_set_lines(0, 0, 0, false, {'hello','world'})
	local line = 0
	vim.api.nvim_buf_set_lines(0, line , line + 1, false, { "line 1", "line 2", "line 3" })
end
 
function NvimToOllamaComplete:bak(opt)
	 
	 local question = [[
Find the apropriate code in response tag.
Answer only the line of  the code with response tag replaced with the code without any comment and explanation:
------------------------------
class Car {
	public:
	int x;
	int y;
	int speed;
	vector<int> positions;
	vector<int> positions;
	Car(int x = 0, int y = 0, int speed = 0) : x(x), y(y), speed(speed) {
	}
	void move() {
		x += speed;
		y += speed;
		<<<RESPONSE>>>
	}
	void get(){
	}
	void setSpeed(int s) {
	}
};
]]
 
  local nvim_to_ollama = NvimToOllama.new()
  local result = nvim_to_ollama:process_chat_api_request(question)
  vim.print("result ---------------------------------")
  vim.print(result)
	 
end
 
function NvimToOllamaComplete:complete(opt)
	--get the current line text
	local current_line = vim.api.nvim_get_current_line()
	local original_current_line = current_line
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	--local start_line = math.max(0, cursor_pos[1] - 3)
	--local end_line = cursor_pos[1] + 3

	local before_file_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, cursor_pos[1] - 1, false), "\n")
	local after_file_content = table.concat(vim.api.nvim_buf_get_lines(0, cursor_pos[1], -1, false), "\n")

	local file_name = vim.api.nvim_buf_get_name(0)
	local file_type = vim.api.nvim_buf_get_option(0, "filetype")
	local msg = ''
	local header = [[Find the apropriate code in response tag.
Answer only the line of  the code with response tag replaced with the code without any comment and explanation:
------------------------------
]]

	msg = header .. "\n\n" .. before_file_content .. "\n" .. current_line .. " <RESPONSE> " .. "\n" .. after_file_content .. "\n"

	local nvim_to_ollama = NvimToOllama.new()
	local result = nvim_to_ollama:process_chat_api_request(msg)

	result = result:gsub("```[^\n]*\n", "")
	result = result:gsub("```", "")
	-- result = result:gsub("\n", "")

	vim.print("result ---------------------------------")
	vim.print(result)
	-- local current_line_number = vim.api.nvim_win_get_cursor(0)[1]
	if result:sub(1, #current_line) ~= current_line then
		result = current_line .. result
	end
	local lines = {}
	for line in result:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end

	vim.api.nvim_buf_set_lines(0, cursor_pos[1] - 1 , cursor_pos[1], false, lines)

end

return NvimToOllamaComplete

