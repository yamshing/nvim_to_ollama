vim.api.nvim_create_user_command("VTOSendSelection", function(opts)
	local NvimToOllama = require("nvim_to_ollama")
	local nvimtollama = NvimToOllama.new()
	nvimtollama:send_selection_to_chat(opts.args)
end, { range = true, nargs = "?" })

