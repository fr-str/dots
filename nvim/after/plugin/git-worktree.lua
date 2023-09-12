require('git-worktree')
require('telescope').load_extension('git_worktree')

vim.keymap.set("n", "<leader>wl", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>")
vim.keymap.set("n", "<leader>wc", "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>")
