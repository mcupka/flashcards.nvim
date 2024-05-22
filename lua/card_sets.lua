local M = {}

--- take json string for a card, and write it to _buffer_ at _line_ with proper
--- formatting. 
--- @param buffer integer buffer to write to 
---@param line integer line to write buffer to
---@param card_json string json string for card
---@param side string side of card to show. ie front or back? 
function M.put_card_line(buffer, line, card_json, side)
    local card = vim.json.decode(card_json)
    vim.print(card)
    vim.api.nvim_buf_set_lines(buffer, line, line, true, {card[side]})
end

local test_card_json = io.open("test/flashcards/foods.json")
if test_card_json then
    local test_contents = test_card_json:read('*a')
    M.put_card_line(0, 0, "{\"front\" : \"ekmek\", \"back\" : \"bread\"}", "back")
end

return M
