 
local test_filter = _G._PLENARY_TEST_FILTER

local function filter(name)
  return not test_filter or string.find(name, test_filter)
end
 
if filter("Hello Test") then
describe("Hello", function()
  it("Test", function()
		vim.print("hello hohoho", vim.api.nvim_get_current_buf())
		local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_lines(1, 10, 10, false, {'hello','world'})
    assert.is_true(true)
  end)
end)
end
 


