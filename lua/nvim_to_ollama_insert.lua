local NvimToOllama = require("nvim_to_ollama")

local NvimToOllamaInsert = {}
NvimToOllamaInsert.__index = NvimToOllamaInsert

function NvimToOllamaInsert.new()
  local self = setmetatable({}, NvimToOllamaInsert)
	 
  return self
end
 
function NvimToOllamaInsert:insert(order)
	 --get the current line text
   local current_line = vim.api.nvim_get_current_line()
   local current_file_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
   local file_name = vim.api.nvim_buf_get_name(0)
   local file_type = vim.api.nvim_buf_get_option(0, "filetype")
	  
   local option_line =  "\n\n <file_name> :" .. file_name .. "\n <filetype>:" .. file_type 
   option_line =  option_line .. "\n<context> : " .. current_file_content .. "\n\n"
   option_line =  option_line .. [[
   <output> : In the response, put only the code without any explanation. 
	 Do not add any extra text.
   Do not add main function to explain the code.
   ]]
   current_line =  "complete this line :" .. current_line .. "\n\n with these options :" .. option_line
   vim.print("current_line ---------------------------------")
   vim.print(current_line)
   local nvim_to_ollama = NvimToOllama.new()
   local result = nvim_to_ollama:process_chat_api_request(current_line)
   result = result:gsub("```[^\n]*\n", "")
   result = result:gsub("```", "")

   
   vim.print(result)
	 
    local lines = {}
    for line in result:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    -- insert the lines of the next line of the current line
    local current_line_number = vim.api.nvim_win_get_cursor(0)[1]
    --local current_line_number = current_line_number + 1
    vim.api.nvim_buf_set_lines(0, current_line_number, current_line_number, false, lines)

    
    
  

end

return NvimToOllamaInsert

