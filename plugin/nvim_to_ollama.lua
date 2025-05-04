
local nto = require('nvim_to_ollama') 
vim.api.nvim_create_user_command("VTOSendLineToChat", nto.send_line_to_chat, {})
