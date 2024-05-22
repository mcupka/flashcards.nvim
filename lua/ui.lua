-- ui.lua is provides functions display flashcards.nvim ui in given buffer

local M = {}

M._ui_header = {
    "------------------",
    "    FLASHCARDS    ",
    "------------------",
}

M._ui_main_menu= {
    "Edit flashcards",
    "Review flashcards",
}

local _ui_menu_start_row = 4

local _ui_header_start_row = 0
local _ui_header_end_row = 2
local flashcards_ns = vim.api.nvim_create_namespace("flashcards")

function M.display_main_menu(buffer, window)
    require("lua.colors")

    vim.api.nvim_set_option_value("cursorline", true, {win=window})
    vim.keymap.set('n', '<CR>', function()
        local selected_option = vim.api.nvim_get_current_line()
        print("selected: " .. selected_option)
    end , {silent = true, buffer = buffer})

    if not vim.api.nvim_buf_is_valid(buffer) then
        print("buffer not valid")
        return
    end

    -- sets the hl namespace for the window
    vim.api.nvim_win_set_hl_ns(window, flashcards_ns)

    -- Writes the header
    vim.api.nvim_buf_set_lines(buffer, 0,
        0, true, M._ui_header)
    vim.api.nvim_buf_set_lines(buffer, _ui_header_end_row + 1,
        _ui_header_end_row + 1, true, {""})

    -- Adds header extmarks 
    for i, line in ipairs(M._ui_header) do
        vim.api.nvim_buf_set_extmark(buffer, flashcards_ns, i - 1, 0, {
            end_col = string.len(M._ui_header[i]),
            end_row = i - 1,
            hl_group = "FlashcardsHeader"
        })
    end

    -- Adds menu option lines
    for i, option in ipairs(M._ui_main_menu) do
       M.put_menu_option(buffer, option, i + _ui_menu_start_row - 1)
    end

    vim.api.nvim_set_option_value('modifiable', false, {buf=buffer})
end

function M.put_menu_option(buffer, option, line)
    vim.api.nvim_buf_set_lines(buffer, line, line, true, {option})
    vim.api.nvim_buf_set_extmark(buffer, flashcards_ns, line, 0, {
        end_col = string.len(option),
        end_row = line,
        hl_group = "FlashcardsMenuOption",
        virt_text = {{"test vtext", "FlashcardsMenuOptionVirtualText"}},
        virt_text_pos = "eol",
    })
end



return M
