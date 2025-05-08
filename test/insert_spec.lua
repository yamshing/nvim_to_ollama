 
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
 

