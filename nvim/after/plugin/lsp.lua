local lsp = require('lsp-zero').preset('recommended')
local nvim_lsp = require('lspconfig')
vim.lsp.set_log_level('debug')


-- Fix Undefined global 'vim'
lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lsp.ensure_installed({
    "gopls",
    "lua_ls",
    "rust_analyzer",
    "eslint",
})

lsp.set_preferences({
    -- suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    -- vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("i", "<M-h>", vim.lsp.buf.signature_help, opts)
    --    vim.keymap.set("n", "<leader>bt", vim.lsp.buf_attach_client, opts)
end)

local servers = {
    solargraph = {
        cmd = { os.getenv("HOME") .. "/.rbenv/shims/solargraph", 'stdio' },
        root_dir = nvim_lsp.util.root_pattern("Gemfile", ".git", "."),
        settings = {
            solargraph = {
                autoformat = true,
                completion = true,
                diagnostic = true,
                folding = true,
                references = true,
                rename = true,
                symbols = true
            }
        }
    }
}

for server, config in pairs(servers) do
    nvim_lsp[server].setup(config)
end


lsp.setup()
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
cmp.setup({
    preselect = cmp.PreselectMode.Item,
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    mapping = cmp.mapping.preset.insert({
        ['<TAB>'] = cmp.mapping.confirm({ select = true }),
    }),
})

vim.diagnostic.config({
    virtual_text = true,
})
