local start_time = os.time()
local buf = vim.api.nvim_get_current_buf()

-- Times
print(buf)


-- run code for test
for i = 1, 10000000 do
  print("a")
end

-- buffer time 

local end_time = os.time()
local time = (end_time - start_time)


--print(time)
--print(line)
