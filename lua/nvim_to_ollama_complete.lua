local NvimToOllama = require("nvim_to_ollama")

local NvimToOllamaComplete = {}
NvimToOllamaComplete.__index = NvimToOllamaComplete

function NvimToOllamaComplete.new()
  local self = setmetatable({}, NvimToOllamaComplete)
	 
  return self
end
 
function NvimToOllamaComplete:complete(opt)
	 --get the current line text
   local current_line = vim.api.nvim_get_current_line()
   local original_current_line = current_line
   local cursor_pos = vim.api.nvim_win_get_cursor(0)
   local start_line = math.max(0, cursor_pos[1] - 3)
   local end_line = cursor_pos[1] + 3
   local current_file_content = table.concat(vim.api.nvim_buf_get_lines(0, start_line, end_line, false), "\n")
	 --vim.print("current_file_content", current_file_content)
   local file_name = vim.api.nvim_buf_get_name(0)
   local file_type = vim.api.nvim_buf_get_option(0, "filetype")
   local option_line =  "\n\n <file_name> :" .. file_name .. "\n <filetype>:" .. file_type 
   option_line =  option_line .. "\n<context> : " .. current_file_content .. "\n\n"
   option_line =  option_line .. [[
   <output> : In the response, put only the code without any explanation. 
   Do not add any extra text.
   Responce must be only the completed line.
   Responce must not contain given line to complete so that it can be used in the next line.
   Responce must not contain <file_name> <filetype> <context> <output> tags.
   ]]
   current_line =  "complete this line :" .. current_line .. "\n\n with these options :" .. option_line
   --vim.print("current_line ---------------------------------")
   --vim.print(current_line)

   local nvim_to_ollama = NvimToOllama.new()
   local result = nvim_to_ollama:process_chat_api_request(current_line)
   -- remove line which start with ```
   result = result:gsub("```[^\n]*\n", "")
   result = result:gsub("```", "")
   result = result:gsub("\n", "")

   vim.print("result ---------------------------------")
   vim.print(result)
	 --set the result to the end of current line
   local current_line_number = vim.api.nvim_win_get_cursor(0)[1]
   -- check if result match the current line at the beginning 
   if result:sub(1, #original_current_line) ~= original_current_line then
      result = original_current_line .. result
   end

   vim.api.nvim_buf_set_lines(0, current_line_number - 1, current_line_number, false, {result})
   



   

end

return NvimToOllamaComplete

