local buf = vim.api.nvim_get_current_buf()

-- Get the content of the first line in the buffer
local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
print(line)

