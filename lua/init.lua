local M = {}

function M.setup()
    local window = require("lua.window")
    local ui = require("lua.ui")
    local b, w = window.create_flashcards_window()
    local card_sets = require("lua.card_sets")
    local test_set = card_sets._sets["Turkish Foods"].cards
    ui.display_main_menu(b, w)
    for i, card in ipairs(test_set) do
        ui.put_card_line(b, 6 + i, card, "front")
    end
    vim.api.nvim_set_option_value('modifiable', false, {buf=b})
end

M.setup()


return M
