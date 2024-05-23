-- ui.lua is provides functions display flashcards.nvim ui in given buffer

local M = {}

---@enum ui_states
local ui_states = {
    init = 0,
    main_menu = 1,
    edit_flashcards = 2
}

M._ui_header = {
    "------------------",
    "    FLASHCARDS    ",
    "------------------",
}

M.ui_menus = {}

M.ui_menus[ui_states.main_menu] = {
    ["Edit flashcards"] = function()
        M._ui_state = ui_states.edit_flashcards
        M.refresh_ui(M._ui_buffer, M._ui_window)
    end ,
    ["Review flashcards"] = function()
        M._ui_state = ui_states.review_flashcards
    end
}

M.ui_menus[ui_states.edit_flashcards] = {
    ["Go back"] = function()
        M._ui_state = ui_states.main_menu
        M.refresh_ui(M._ui_buffer, M._ui_window)
    end
}


---holds state of the screen
---@type ui_states
M._ui_state = ui_states.init

local _ui_menu_start_row = 4

local _ui_header_end_row = 2
local flashcards_ns = vim.api.nvim_create_namespace("flashcards")

function M.refresh_ui(buffer, window)
    vim.api.nvim_set_option_value('modifiable', true, {buf=buffer})

    -- Writes the header
    vim.api.nvim_buf_set_lines(buffer, 0,
        0, true, M._ui_header)
    vim.api.nvim_buf_set_lines(buffer, _ui_header_end_row + 1,
        _ui_header_end_row + 1, true, { "" })

    -- Adds header extmarks
    for i, line in ipairs(M._ui_header) do
        vim.api.nvim_buf_set_extmark(buffer, flashcards_ns, i - 1, 0, {
            end_col = string.len(M._ui_header[i]),
            end_row = i - 1,
            hl_group = "FlashcardsHeader"
        })
    end

    local option_line = _ui_menu_start_row - 1
    for option, _ in pairs(M.ui_menus[M._ui_state]) do
        vim.print(option)
        M.put_menu_option(buffer, option, option_line)
        option_line = option_line + 1
    end

    vim.api.nvim_set_option_value('modifiable', false, {buf=buffer})
end

function M.initialize_ui(buffer, window)
    require("lua.colors")

    M._ui_state = ui_states.main_menu
    vim.api.nvim_set_option_value("cursorline", true, { win = window })
    vim.keymap.set('n', '<CR>', function()
        local selected_option = vim.api.nvim_get_current_line()
        print("selected: " .. selected_option)
        if M.ui_menus[M._ui_state][selected_option] ~= nil then
            M.ui_menus[M._ui_state][selected_option]()
        else
        end
    end, { silent = true, buffer = buffer })

    if not vim.api.nvim_buf_is_valid(buffer) then
        print("buffer not valid")
        return
    end

    -- sets the hl namespace for the window
    vim.api.nvim_win_set_hl_ns(window, flashcards_ns)

    M._ui_buffer = buffer
    M._ui_window = window

    -- clears and redraws the UI according to what the state is
    M.refresh_ui(buffer, window)
end

--- take table for a card, and write it to _buffer_ at _line_ with proper
--- formatting.
--- @param buffer integer buffer to write to
---@param line integer line to write buffer to
---@param card string table for card i.e. {front = ..., back = ...}
---@param side string side of card to show. ie front or back?
function M.put_card_line(buffer, line, card, side)
    vim.api.nvim_set_option_value('modifiable', true, {buf=buffer})
    vim.api.nvim_buf_set_lines(buffer, line, line, false, { card[side] })
    vim.api.nvim_buf_set_extmark(buffer, flashcards_ns, line, 0, {
        virt_text = { { side == "front" and card["back"] or card["front"],
            "FlashcardsMenuOptionVirtualText" } },
        virt_text_pos = "eol",
    })
    vim.api.nvim_set_option_value('modifiable', false, {buf=buffer})
end

function M.put_menu_option(buffer, option, line)
    vim.api.nvim_set_option_value('modifiable', true, {buf=buffer})
    vim.api.nvim_buf_set_lines(buffer, line, line, true, { option })
    vim.api.nvim_buf_set_extmark(buffer, flashcards_ns, line, 0, {
        end_col = string.len(option),
        end_row = line,
        hl_group = "FlashcardsMenuOption",
        virt_text = { { "test vtext", "FlashcardsMenuOptionVirtualText" } },
        virt_text_pos = "eol",
    })
    vim.api.nvim_set_option_value('modifiable', false, {buf=buffer})
end

return M
