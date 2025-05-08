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
   current_line =  current_line .. ": file_name: " .. file_name .. " filetype: " .. file_type 
   --current_line =  current_line .. " file_content: " .. current_file_content

   current_line =  current_line .. [[: In the response, put only the code without any explanation. 
   Do not add any extra text.
   Do not add main function to explain the code.
   ]]
   local nvim_to_ollama = NvimToOllama.new()
   local result = nvim_to_ollama:process_chat_api_request(current_line)
   --vim.print("current_line", current_line)
   vim.print(result)


   

end

return NvimToOllamaInsert

