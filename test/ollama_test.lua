package.path = package.path .. ";../lua/?.lua"

local user_text =  [[
Find the apropriate code in response tag.
Answer only the line of  the code with response tag replaced with the code without any comment and explanation:
------------------------------
class Car {
	public:
	int x;
	int y;
	int speed;
	vector<int> positions;
	vector<int> positions;
	Car(int x = 0, int y = 0, int speed = 0) : x(x), y(y), speed(speed) {
	}
	void move() {
		x += speed;
		y += speed;
		<<<RESPONSE>>>
	}
	void get(){
	}
	void setSpeed(int s) {
	}
};
]]
user_text = [[
Make me the main function in cpp.
Answer only the code without any comment and explanation:
]]
 
user_text = [[
language is cpp.
Make me a class called User with name, age, adress. Separate .h and .cpp.
Answer only the code without any comment and explanation:
]]
 
user_test =[[

```cpp
// User.h
#ifndef USER_H
#define USER_H

class User {
public:
  std::string getName();
  int getAge();
  std::string getAddress();
  void setName(const std::string& name);
  void setAge(int age);
  void setAddress(const std::string& address);

private:
  std::string name;
  int age;
  std::string address;
};

#endif
```

```cpp
// User.cpp
#include "User.h"

std::string User::getName() {
  return name;
}
int User::getAge() {
  return age;
}
std::string User::getAddress() {
  return address;
}
void User::setName(const std::string& name) {
  this->name = name;
}
void User::setAge(int age) {
  this->age = age;
}
void User::setAddress(const std::string& address) {
  this->address = address;
}
```

-----------------------
language is cpp.
add a variable string phone_number to User class above
Answer only the code without any comment and explanation:
]]


user_test =[[
add a variable string phone_number to User class
Answer only the code without any comment and explanation:
]]
 
local payload = {
	--model = "gemma2",
	model = "qwen2.5-coder",
	messages = {
		{ role = "system", content = "You are a professional programmer." },
		{ role = "user", content = user_text },
	}
}

local json = require("dkjson")
local json_payload = json.encode(payload)

local handle = io.popen("curl -s -H 'Content-Type: application/json' -d '" .. json_payload .. "' http://localhost:11434/v1/chat/completions")
local result = handle:read("*a")
handle:close()

local function print_table(tbl, indent)
    indent = indent or 0
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            print_table(v, indent + 1)
        else
            print(formatting .. tostring(v))
        end
    end
end

local res_json = json.decode(result)
print(res_json.choices[1].message.content)


