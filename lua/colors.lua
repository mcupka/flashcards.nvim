-- highlights used for Flashcards UI
--
local hl_groups = {
    FlashcardsHeader = {fg = "#C0C0C0", bg = "#9933FF", default = true },
    FlashcardsMenuOption = {fg = "#FFFFFF", bg = "#000000", default = true },
    FlashcardsMenuOptionVirtualText = {link = "Comment", default = true },
}

local hl_ns = vim.api.nvim_create_namespace("flashcards")
for name, hl in pairs(hl_groups) do
    vim.api.nvim_set_hl(hl_ns, name, hl)
end
