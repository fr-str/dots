
function ColourMy(colour)
	colour = colour or 'vim-monokai-tasty'
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0,"Normal", {bg = "none"})
	vim.api.nvim_set_hl(0,"NormalFloat", {bg = "none"})
end

ColourMy()

