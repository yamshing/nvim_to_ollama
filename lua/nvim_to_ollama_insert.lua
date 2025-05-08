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
   local file_name = vim.api.nvim_buf_get_name(0)
   local file_type = vim.api.nvim_buf_get_option(0, "filetype")
   current_line =  current_line .. ": file_name: " .. file_name .. " filetype: " .. file_type
   local nvim_to_ollama = NvimToOllama.new()
   local result = nvim_to_ollama:process_chat_api_request(current_line)
   vim.print("current_line", current_line)
   vim.print(result)


   

end

return NvimToOllamaInsert

