-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use({
        'patstockwell/vim-monokai-tasty',
        config = function()
            vim.cmd('colorscheme vim-monokai-tasty')
        end
    })
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use('christoomey/vim-tmux-navigator')
    use { "akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
    end }
    use { 'zbirenbaum/copilot.lua', cmd = 'Copilot', event = 'InsertEnter', config = function()
        require("copilot").setup({
            panel = {
                auto_refresh = true,
            },
            suggestion = {
                auto_trigger = true,
            },
            filetypes = {
                ["*"] = true,
            }
        })
    end
    }
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('mbbill/undotree')
    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    })
    use('tpope/vim-commentary')
    use('tpope/vim-surround')
    use('theprimeagen/harpoon')
    use {
        'williamboman/mason.nvim',
        run = ":MasonUpdate",
    }


    use('mg979/vim-visual-multi')
    use("fatih/vim-go", { run = ":GoUpdateBinaries" })
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
end)
