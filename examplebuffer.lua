local start_time = nil
local end_time = nil
local json_file = "~/Documents/projects/productivity-tracker-nvim/buffer_times.json"

-- Function to load JSON data from a file
local function load_json_file(file)
    local f = io.open(file, "r")
    if f then
        local content = f:read("*a")
        f:close()
        return vim.json.decode(content) or {}
    end
    return {}
end
-- Function to save JSON data to a file
local function save_json_file(file, data)
    local f = io.open(file, "w")
    if f then
        f:write(vim.json.encode(data))
        f:close()
    else
        print("Error: Could not write to file", file)
    end
end

local function start_timer(bufnr)
    start_time = os.time()
    print("Timer started for buffer", bufnr)
end

local function stop_timer(bufnr)
    end_time = os.time()
    if start_time then
        local time_spent = end_time - start_time
        print("Time spent in buffer " .. bufnr .. ": " .. time_spent .. " seconds")

        -- Load existing JSON data
        local data = load_json_file(json_file)

        -- Update buffer time or add new entry
        data[bufnr] = (data[bufnr] or 0) + time_spent

        -- Save updated data to JSON file
        save_json_file(json_file, data)
    else
        print("Timer was not started.")
    end
    start_time = nil
end

local function attach_timer_to_buffer(bufnr)
    vim.api.nvim_buf_attach(bufnr, false, {
        on_detach = function(_, b)
            stop_timer(b)
        end,
        on_lines = function(_, b)
            if not start_time then
                start_timer(b)
            end
        end,
    })
end

-- Define Neovim commands to manually start and stop the timer
vim.api.nvim_create_user_command('StartTimer', function()
    start_timer(vim.api.nvim_get_current_buf())
end, {})

vim.api.nvim_create_user_command('StopTimer', function()
    stop_timer(vim.api.nvim_get_current_buf())
end, {})

-- Attach to the current buffer
attach_timer_to_buffer(vim.api.nvim_get_current_buf())

