-- load snippets from path/of/your/nvim/config/my-cool-snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
-- local k = require("luasnip.nodes.key_indexer").new_key
-- local cmp = require'cmp'
-- cmp.setup({
--     snippet={
--         expand = function(args)
--             require('luasnip').lsp_expand(args.body)
--         end,
--     },
--     sources = {
--         { name = 'nvim_lsp' },
--         { name = 'luasnip' },
--         { name = 'buffer' },
--         { name = 'path' },
--         { name = 'tmux' },
--     },
-- })
ls.setup({
    store_selection_keys = "<Tab>",
})


local function capture(line, trigger)
    if line == "" then
        return ""
    end

    local str = line:sub(1, - #trigger - 1)
    if str == "" then
        return ""
    end

    local lastComponent = ""
    local x = 0
    for i = #str, 1, -1 do
        local char = str:sub(i, i)
        if not char:match("[a-zA-Z0-9%.%(%)%[%]%{%}%\"]") and x == 0 then
            return lastComponent
        end

        if char == ')' or char == ']' then
            x = x + 1
        end

        if char == '(' or char == '[' then
            x = x - 1
            if x < 0 then
                return lastComponent
            end
        end

        lastComponent = char .. lastComponent
    end

    return lastComponent
end
ls.add_snippets("go", {
    postfix(".str", {
        f(function(_, parent)
            return "string(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
        end, {})
    }, {}, { match_pattern = "[a-zA-Z0-9%.%(%)%[%]%{%}%\"]+" })
})
--"[a-zA-Z0-9%.%(%)%[%]%{%}%\"]+"
