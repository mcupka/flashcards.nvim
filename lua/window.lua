-- window.lua is meant to wrap nvim's window api to suit flashcards.nvim needs

local M = {}

function M.create_flashcards_window()
    local b = vim.api.nvim_create_buf(true, true)
    local ui_width = vim.api.nvim_win_get_width(0)
    local w = vim.api.nvim_open_win(b, true,
        { split = 'right', width = math.floor(ui_width / 2) })
    return b, w
end

return M
