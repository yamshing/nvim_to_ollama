
vim.api.nvim_create_user_command("VTOSendSelection", function()
	--require("nvim_to_ollama").send_selection_to_chat()
	local Vimollama = require("vimollama")
	local vimollama = Vimollama.new()
	vimollama:send_selection_to_chat()
	 
end, { range = true })

