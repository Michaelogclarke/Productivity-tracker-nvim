local start_time = nil
local end_time = nil

local function start_timer(bufnr)
    start_time = os.time()
    print("Timer started for buffer", bufnr)
end

local function stop_timer(bufnr)
    end_time = os.time()
    if start_time then
        local time_spent = end_time - start_time
        print("Time spent in buffer " .. bufnr .. ": " .. time_spent .. " seconds")
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

-- Define a Neovim command to start the timer manually
vim.api.nvim_create_user_autocmd('StartTimer', function()
    start_timer(vim.api.nvim_get_current_buf())
end, {})

vim.api.nvim_create_user_command('StopTimer', function()
    stop_timer(vim.api.nvim_get_current_buf())
end, {})


-- Attach to the current buffer
attach_timer_to_buffer(vim.api.nvim_get_current_buf())

