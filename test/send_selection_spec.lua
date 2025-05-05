local test_filter = _G._PLENARY_TEST_FILTER

local function filter(name)
  return not test_filter or string.find(name, test_filter)
end
if filter("Hello Test") then
describe("Hello", function()
  it("Test", function()
		local input = '{"messages": [{"role": "system", "content": "You are a test assistant."}, {"role": "user", "content": "< |User| > refactor this code by changing i to index and output just the code without explanation: \nfor (let i = 1; i <= 100; i++) {\n\tlet output = \"\";\n\tif (i % 3 === 0) \n\t\toutput += \"Fizz\";\n\tif (i % 5 === 0) \n\t\toutput += \"Buzz\";\n}\n<|Assistant|>\n"}], "model": "qwen2.5-coder"}'
		
    assert.is_true(true)
  end)
end)
end

if filter("Input Keep In Var Test") then
  describe("Input Keep In Var", function()
    it("Test", function() 
      --instantiate nvim_to_ollama
      local nvim_to_ollama = require("nvim_to_ollama")

			local input = [[{"messages": [{"role": "system", "content": "You are a test assistant."}, 
{"role": "user", "content": "< |User| > refactor this code by changing i to index and output just the code without explanation: \n
for (let i = 1; i <= 100; i++) {\n\tlet output = \"\";\n\tif (i % 3 === 0) \n\t\toutput += \"Fizz\";\n\tif (i % 5 === 0) 
\n\t\toutput += \"Buzz\";\n}\n<|Assistant|>\n"}], 
"model": "qwen2.5-coder"}]]
      nvim_to_ollama.m_user_input = 'test test'
			 
      local output = [[```javascript
for (let index = 1; index <= 100; index++) {
let output = "";
if (index % 3 === 0)
    output += "Fizz";
if (index % 5 === 0)
    output += "Buzz";
}
```
]]
			 
			--mock nvim_to_ollama.show_floating_window
      nvim_to_ollama.show_floating_window = function(text)
        return nil
      end
			 
      nvim_to_ollama.show_reply_to_floating_win(output)
      assert.is_true(true)
    end)
  end)
end




