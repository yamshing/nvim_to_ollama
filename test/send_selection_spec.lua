 
local test_filter = _G._PLENARY_TEST_FILTER

local function filter(name)
  return not test_filter or string.find(name, test_filter)
end
 
if filter("Hello Test") then
describe("Hello", function()
  it("Test", function()
    assert.is_true(true)
  end)
end)
end
 

if filter("NvimToOllama Diff Test") then
  describe("NvimToOllama Diff", function()
    it("Test", function() 
			local NvimToOllama = require('nvim_to_ollama')
			local nvimtoollama = NvimToOllama.new()
			local output = [[```js
for (let index = 1; index <= 100; index++) { 
let output = ""; 
if (index % 3 === 0)  
	output += "Fizz"; 
if (index % 5 === 0)  
	output += "Buzz"; 
} 
``` ]]

	
			nvimtoollama.m_user_input = [[for (let i = 1; i <= 100; i++) {
let output = "";
if (i % 3 === 0) 
	output += "Fizz";
if (i % 5 === 0) 
	output += "Buzz";
}]]
				local expected_diff =[[-for (let i = 1; i <= 100; i++) {,
+for (let index = 1; index <= 100; index++) {,
 let output = "";,
-if (i % 3 === 0) ,
+if (index % 3 === 0) ,
 output += "Fizz";,
-if (i % 5 === 0) ,
+if (index % 5 === 0) ,
 output += "Buzz";,
 },
]]
 
			nvimtoollama.show_diff_floating_window = function(self, diff_lines)
				 
				local joined_diff = table.concat(vim.list_slice(diff_lines, 4), ",")
				joined_diff = joined_diff:gsub("\n", "")
				joined_diff = joined_diff:gsub("%s+", " ")
				 
				expected_diff = expected_diff:gsub("\n", "")
				expected_diff = expected_diff:gsub("%s+", " ")

				assert.is_equal(joined_diff, expected_diff)
				 
			end
      nvimtoollama:show_reply_to_floating_win(output)
			 
		end)
	end)
end
if filter("NvimToOllama Diff Line Test") then
  describe("NvimToOllama Diff Line", function()
    it("Test", function() 
			local NvimToOllama = require('nvim_to_ollama')
			local nvimtoollama = NvimToOllama.new()
			 
			local expected_diff_str =[[-for (let i = 1; i <= 100; i++) {,
+for (let index = 1; index <= 100; index++) {,
 let output = "";,
-if (i % 3 === 0) ,
+if (index % 3 === 0) ,
 output += "Fizz";,
-if (i % 5 === 0) ,
+if (index % 5 === 0) ,
 output += "Buzz";,
 },
]]

			expected_diff_str = expected_diff_str:gsub("\n", "")
			local expected_diff = vim.split(expected_diff_str, ",")
			--vim.print(expected_diff)
			local left_lines, right_lines, left_hl, right_hl  = nvimtoollama:set_diff_lines(expected_diff)
			--vim.print('diff line res ------------------------------')
			--vim.print(left_lines)
      local expected_left_lines = {
			'for (let i = 1; i <= 100; i++) {',
      'let output = "";',
      'if (i % 3 === 0) ',
      'output += "Fizz";',
      'if (i % 5 === 0) ',
      'output += "Buzz";',
      '}',
      ''}
			 
			assert.same(left_lines, expected_left_lines)
			local expected_right_lines = { 
				"for (let index = 1; index <= 100; index++) {", 
				'let output = "";', 
				"if (index % 3 === 0) ", 
				'output += "Fizz";', 
				"if (index % 5 === 0) ", 
				'output += "Buzz";', "}", "" }
				 
			assert.same(right_lines, expected_right_lines)
			assert.same(left_hl,{"DiffDelete", false, "DiffDelete", false, "DiffDelete", false, false, false })
			assert.same(right_hl,{ "DiffAdd", false, "DiffAdd", false, "DiffAdd", false, false, false })
			 
		end)
	end)
end
 
if filter("NvimToOllama Input Test") then
describe("NvimToOllama Input", function()
	it("Test", function()
		local NvimToOllama = require('nvim_to_ollama')
		NvimToOllama.get_visual_selection = function()
			return "test string"
		end
		 
		NvimToOllama.process_chat_api_request = function(self, use_text)
			--vim.print('use text------------------------------')
			--vim.print(use_text)
			assert.same(use_text,[[< |User| > refactor this code by changing i to index and output just the code without explanation. Add ``` to show the language used:
test string
<|Assistant|>]])
			return nil
		end
		local nvimtoollama = NvimToOllama.new()
		nvimtoollama:send_selection_to_chat('refactor this code by changing i to index and output just the code without explanation. Add ``` to show the language used:')
    --assert.is_true(true)
  end)
end)
end
 

	
 
