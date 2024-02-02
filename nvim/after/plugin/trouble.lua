
vim.keymap.set("n", "<leader>tt", function() require("trouble").toggle() end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
