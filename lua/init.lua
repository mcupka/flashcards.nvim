local M = {}

function M.setup()
    local window = require("lua.window")
    local ui = require("lua.ui")
    local b, w = window.create_flashcards_window()
    ui.display_main_menu(b, w)
    -- vim.api.nvim_buf_set_lines(b, 0, 0, false, {
    --     'This is a line',
    --     'This is another line'
    -- })
end

M.setup()


return M
