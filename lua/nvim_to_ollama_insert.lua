local NvimToOllamaInsert = {}
NvimToOllamaInsert.__index = NvimToOllamaInsert

function NvimToOllamaInsert.new()
  local self = setmetatable({}, NvimToOllamaInsert)
	 
  return self
end
 
function NvimToOllamaInsert:insert(order)
	 --get the current line text
   local current_line = vim.api.nvim_get_current_line()
   vim.print("current_line", current_line)
   
end

return NvimToOllamaInsert

