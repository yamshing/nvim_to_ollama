function test()
	-- use vim.api to get buffer content
local buffer_content = vim.api.nvim_get_current_line()
local all_buffer_content = table.concat(vim.fn.getline(1, '$'))
--get file name of the current buffer
local file_name = vim.fn.expand('%')
--get cursor position 
-- get cursor position
local cursor_position = vim.api.nvim_win_get_cursor(0)
print("Cursor position: " .. tostring(cursor_position))
-- make array of some random texts for test 
end
