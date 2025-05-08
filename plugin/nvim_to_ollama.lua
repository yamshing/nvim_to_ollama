
vim.api.nvim_create_user_command("VTOSendSelection", function()
	--require("nvim_to_ollama").send_selection_to_chat()
	local NvimToOllama = require("nvim_to_ollama")
	local nvimtollama = NvimToOllama.new()
	nvimtollama:send_selection_to_chat()
	 
end, { range = true })

