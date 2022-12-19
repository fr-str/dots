local lsp = require('lsp-zero')

lsp.preset('recommended')
-- Fix Undefined global 'vim'
lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lsp.set_preferences({
    sign_icons ={
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I',
    }
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
