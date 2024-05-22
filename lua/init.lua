local M = {}

function M.setup()
    local window = require("lua.window")
    local ui = require("lua.ui")
    local b, w = window.create_flashcards_window()
    ui.display_main_menu(b, w)
end

M.setup()


return M
