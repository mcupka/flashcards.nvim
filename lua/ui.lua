-- ui.lua is provides functions display flashcards.nvim ui in given buffer

local M = {}

M._ui_header = {
    "------------------",
    "    FLASHCARDS    ",
    "------------------",
}

M._ui_header_hilight = "FlashcardsHeader"

local _ui_header_start_row = 0
local _ui_header_end_row = 1
local hl_ns = vim.api.nvim_create_namespace("flashcards")

function M.display_main_menu(buffer, window)
    require("lua.colors")
    if not vim.api.nvim_buf_is_valid(buffer) then
        print("buffer not valid")
        return
    end

    -- Writes the header
    vim.api.nvim_buf_set_lines(buffer, _ui_header_start_row,
        _ui_header_end_row, true, M._ui_header)

    -- Adds header extmarks 
    vim.api.nvim_win_set_hl_ns(window, hl_ns)
    for i, line in ipairs(M._ui_header) do
        vim.api.nvim_buf_set_extmark(buffer, hl_ns, i - 1, 0, {
            end_col = string.len(M._ui_header[i]),
            end_row = i - 1,
            hl_group = M._ui_header_hilight
        })
    end

    -- Adds menu option lines
end


return M
