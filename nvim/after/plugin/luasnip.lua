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

ls.add_snippets("go", {
    postfix(".str", {
        f(function(_, parent)
            return "string(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
        end, {})
    }),
    postfix(".len", {
        f(function(_, parent)
            return "len(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
        end, {})
    }),
    postfix(".bytes", {
        f(function(_, parent)
            return "[]byte(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
        end, {})
    })
})
