local M = {}

-- Collections look like this:
-- {
--     name: "A collection",
--     sets: [ "A Set", "Another Set"]
--     tags: [ "A tag", "Another tag"]
-- }

-- global list of all collections. Starts blank.
M._collections = {}
M._sets = {}

--- loads flashcard collections and sets from files
---@param filenames table list of files to search for card sets and collections
local function load_collections(filenames)
    for _, fname in ipairs(filenames) do
        local file = io.open(fname)
        if file then
            local file_contents = file:read('*a')
            local file_table = vim.json.decode(file_contents)

            if file_table.name ~= nil and file_table.sets ~= nil then
                if M._collections[file_table.name] ~= nil then
                    table.insert(M._collections[file_table.name].sets,
                        file_table.sets)
                    table.insert(M._collections[file_table.name].tags,
                        file_table.tags)
                else
                    M._collections[file_table.name] = {
                        sets = file_table.sets,
                        tags = file_table.tags
                    }
                end
            elseif file_table.name ~= nil and file_table.cards ~= nil then
                if M._collections[file_table.name] ~= nil then
                    table.insert(M._sets[file_table.name].cards,
                        file_table.cards)
                    table.insert(M._sets[file_table.name].tags,
                        file_table.tags)
                else
                    M._sets[file_table.name] = {
                        cards = file_table.cards,
                        tags = file_table.tags
                    }
                end
            end
        end
    end
end



-- finds flashcard json files and passes them to load_collections
local flashcards_files = vim.fs.find(function(name, path)
    return name:match('.*%.json$') and path:match('[/\\\\]flashcards$')
end, { limit = math.huge, type = 'file' })

load_collections(flashcards_files)

return M
