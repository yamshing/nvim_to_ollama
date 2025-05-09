vim.api.nvim_create_user_command("VTOSendSelection", function(opts)
	local NvimToOllama = require("nvim_to_ollama")
	local nvimtollama = NvimToOllama.new()
	nvimtollama:send_selection_to_chat(opts.args)
end, { range = true, nargs = "?" })
 
vim.api.nvim_create_user_command("VTOInsert", function(opts)
	local NvimToOllamaInsert = require("nvim_to_ollama_insert")
	local nvim_to_ollama_insert = NvimToOllamaInsert.new()
	nvim_to_ollama_insert:insert(opts.args)
end, { range = true, nargs = "?" })

vim.api.nvim_create_user_command("VTOComplete", function(opts)
	local NvimToOllamaComplete = require("nvim_to_ollama_complete")
	local nvim_to_ollama_complete = NvimToOllamaComplete.new()
	nvim_to_ollama_complete:complete(opts.args)
end, { range = true, nargs = "?" })



