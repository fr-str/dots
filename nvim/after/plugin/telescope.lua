local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n' ,'<leader>fs',builtin.grep_string,{})
vim.keymap.set('n' ,'<leader>fg',builtin.live_grep,{})
vim.keymap.set('n' ,'<leader>bb',builtin.buffers,{})
vim.keymap.set('n' ,'<leader>lr',builtin.lsp_references,{})
vim.keymap.set('n' ,'<leader>tt',builtin.treesitter,{})
