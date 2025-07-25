vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- tab size 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.showmode = false

vim.opt.clipboard = "unnamedplus"

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

vim.opt.cursorline = true
vim.opt.guicursor = "n-v-c-i:block-Cursor"
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15

vim.opt.hlsearch = true
-- KEYMAPS
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>ih", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Show [I]nlay [H]ints" })

-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- void paste
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "<leader>fb", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- vim.keymap.set({ "n", "v" }, "<leader>y", require('osc52').copy_visual)

local function toggle_tilde_wrap()
	-- get line
	local line = vim.fn.getline(".")
	-- select text ignoring whitespace
	local text = vim.fn.substitute(line, "^\\s*\\|\\s*$", "", "g")
	-- if text has tilde, remove it
	if string.find(text, "~") then
		text = string.gsub(text, "~", "")
	else
		-- add tilde to the beginning of the line and end of the text
		text = "~" .. text .. "~"
	end
	-- replace the line with tilde wrapped text
	vim.fn.setline(".", text)
end

vim.keymap.set("n", "<leader>~", toggle_tilde_wrap, { desc = "Toggle ~ wrap" })
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- ain file type
vim.filetype.add({
	extension = {
		ain = "ain",
	},
})
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("FixAinCommentString", { clear = true }),
	callback = function(ev)
		vim.bo[ev.buf].commentstring = "# %s"
	end,
	pattern = { "ain" },
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup({
	"tpope/vim-sleuth",
	-- -- "gc" to comment visual regions/lines
	-- { "numToStr/Comment.nvim", opts = {} },
	-- See `:help gitsigns` to understand what the configuration keys do
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()
			-- Document existing key chains
			require("which-key").add({
				{ "<leader>c", group = "[C]ode", hidden = true },
				{ "<leader>d", group = "[D]ocument", hidden = true },
				{ "<leader>r", group = "[R]ename", hidden = true },
				{ "<leader>s", group = "[S]earch", hidden = true },
				{ "<leader>w", group = "[W]orkspace", hidden = true },
			})
		end,
	},
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			--  :Telescope help_tags
			--  - Normal mode: ?
			-- See `:help telescope` and `:help telescope.setup()`
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help teleecope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			-- vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set(
				"n",
				"<leader>sl",
				builtin.spell_suggest,
				{ desc = '[S]earch Recent Files ("." for repeat)' }
			)
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local buitin = require("telescope.builtin")
					map("gd", buitin.lsp_definitions, "[G]oto [D]efinition")
					map("gr", buitin.lsp_references, "[G]oto [R]eferences")
					map("gI", buitin.lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", buitin.lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", buitin.lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>lws", buitin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				clangd = {},
				gopls = {
					settings = {
						gopls = { gofumpt = true },
					},
				},

				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
				openscad_lsp = {
					cmd = { "openscad-lsp", "--stdio", "--fmt-style", "LLVM" },
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("FixOpenSCADCommentString", { clear = true }),
				callback = function(ev)
					vim.bo[ev.buf].commentstring = "// %s"
				end,
				pattern = { "openscad", "scad" },
			})

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				-- javascript = { { "prettierd", "prettier" } },
			},
		},
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"fr-str/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
			},
			"saadparwaiz1/cmp_luasnip",

			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
			local postfix = require("luasnip.extras.postfix").postfix

			luasnip.add_snippets("go", {
				postfix(".str", {
					luasnip.function_node(function(_, parent)
						return "string(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
					end, {}),
				}),
				postfix(".len", {
					luasnip.function_node(function(_, parent)
						return "len(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
					end, {}),
				}),
				postfix(".int", {
					luasnip.function_node(function(_, parent)
						return "int(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
					end, {}),
				}),

				postfix(".int64", {
					luasnip.function_node(function(_, parent)
						return "int64(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
					end, {}),
				}),
				postfix(".int32", {
					luasnip.function_node(function(_, parent)
						return "int32(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
					end, {}),
				}),
				postfix(".int16", {
					luasnip.function_node(function(_, parent)
						return "int16(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
					end, {}),
				}),
				postfix(".int8", {
					luasnip.function_node(function(_, parent)
						return "int8(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
					end, {}),
				}),
				postfix(".bytes", {
					luasnip.function_node(function(_, parent)
						return "[]byte(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
					end, {}),
				}),
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					-- ["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-k>"] = cmp.mapping.confirm({ select = true }),
					["<M-k>"] = cmp.mapping.complete({}),

					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
			cmp.setup.filetype({ "sql" }, {
				sources = {
					{ name = "vim-dadbod-completition" },
					{ name = "buffer" },
				},
			})
		end,
	},
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
	{
		"aktersnurra/no-clown-fiesta.nvim",
		config = function()
			vim.cmd("colorscheme no-clown-fiesta")
			vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
		end,
	},
	-- {
	-- 	"kepano/flexoki-neovim",
	-- 	name = "flexoki",
	-- 	lazy = false,
	-- 	priority = 100,
	-- 	config = function()
	-- 		vim.cmd("colorscheme flexoki-dark")
	-- 		vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
	-- 		local base = require("flexoki.highlights.base")
	-- 		local bg = base.groups()
	-- 		local c = require("flexoki.palette").palette()
	-- 		bg["Pmenu"] = { fg = c["tx-2"], bg = c["bg-2"], sp = "NONE", blend = 50 }
	--
	-- 		base.groups = function()
	-- 			return bg
	-- 		end
	-- 	end,
	-- },
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"OXY2DEV/markview.nvim",
		},
		lazy = false,
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "bash", "c", "html", "lua", "markdown", "vim", "vimdoc", "go", "zig" },
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		config = function(_, opts)
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.ain = {
				install_info = {
					url = "~/code/tree-sitter-ain",
					files = { "src/parser.c" },
					generate_requires_npm = false,
					requires_generate_from_grammar = false,
				},
				filetype = "ain",
			}
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended
		-- ft = "markdown" -- If you decide to lazy-load anyway
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"chrisgrieser/nvim-chainsaw",
		config = function()
			local chain = require("chainsaw")
			chain.setup({
				marker = "[dupa]",
				logStatements = {
					variableLog = {
						-- go = 'fmt.Fprintln(config.LogFile,"%s %s: ",%s)',
						-- go = 'log.Trace("{{marker}}",log.Any("{{var}}",{{var}}))',
						go = 'fmt.Println("{{marker}} {{var}}: ",{{var}})',
						zig = 'std.debug.print("{{marker}} {{var}}: {any}\\n",.{{{var}}});',
					},
					objectLog = {
						go = 'e := json.NewEncoder(os.Stdout)/*{{marker}}*/; e.SetIndent("", " ")/*{{marker}}*/; e.Encode({{var}})/*{{marker}}*/',
						-- go = 'log.Trace("{{marker}}",log.JSON({{var}}))',
						-- go = '/*{{marker}}*/b,_:=json.MarshalIndent({{var}},""," ");fmt.Println(string(b))//[dupa]',
					},
				},
			})
			vim.keymap.set({ "n", "v" }, "<leader>ol", chain.objectLog)
			vim.keymap.set({ "n", "v" }, "<leader>vl", chain.variableLog)
			vim.keymap.set({ "n", "v" }, "<leader>rl", chain.removeLogs)
		end,
	},
	{
		"theprimeagen/harpoon",
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>a", mark.add_file)
			vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
		end,
	},
	{
		"ThePrimeagen/git-worktree.nvim",
		config = function()
			require("git-worktree")
			require("telescope").load_extension("git_worktree")

			vim.keymap.set(
				"n",
				"<leader>wl",
				"<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>"
			)
			vim.keymap.set(
				"n",
				"<leader>wc",
				"<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>"
			)
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup()
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				direction = "float",
				float_opts = {
					border = "curved",
				},
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
				end,
				-- function to run on closing the terminal
				on_close = function(term)
					vim.cmd("startinsert!")
				end,
			})

			function _lazygit_toggle()
				lazygit:toggle()
			end

			vim.api.nvim_set_keymap(
				"n",
				"<leader>lg",
				"<cmd>lua _lazygit_toggle()<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_set_keymap("n", "<C-t>", ":ToggleTerm direction=vertical size=100<CR>", { noremap = true })
			vim.api.nvim_set_keymap("t", "<C-t>", "<C-\\><C-n>:ToggleTerm<CR>", { noremap = true })
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {
			focus = true,
		}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>q",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		config = function()
			vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
			vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
			vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
			vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local nvim_tree = require("nvim-tree")
			local api = require("nvim-tree.api")

			local function edit_or_open()
				local node = api.tree.get_node_under_cursor()

				if node.nodes ~= nil then
					-- expand or collapse folder
					api.node.open.edit()
				else
					-- open file
					api.node.open.edit()
					-- Close the tree if file was opened
					api.tree.close()
				end
			end

			nvim_tree.setup({
				on_attach = function(bufnr)
					api.config.mappings.default_on_attach(bufnr)
					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end
					vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
					vim.keymap.set("n", "h", api.tree.close, opts("Close"))
					vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
				end,
				filters = {
					dotfiles = true,
				},
			})
		end,
	},
	{ "tpope/vim-surround" },
	{
		"fatih/vim-go",
		config = function()
			vim.cmd('let g:go_fmt_command="gopls"')
			vim.cmd("let g:go_gopls_gofumpt=1")
			function GoTag(add)
				local tag = vim.fn.input("Enter tag: ")
				if add then
					vim.cmd("GoAddTags " .. tag)
				else
					vim.cmd("GoRemoveTags " .. tag)
				end
			end

			vim.keymap.set("n", "<leader>grt", "<cmd>lua GoTag(false)<CR>")
			vim.keymap.set("n", "<leader>gat", "<cmd>lua GoTag(true)<CR>")
			vim.keymap.set("n", "<leader>gts", "<cmd>GoTestSum<CR>")
			vim.keymap.set("n", "<leader>ger", "<cmd>GoIfErr<CR>")
			vim.keymap.set("n", "<leader>gfs", "<cmd>GoFillStruct<CR>")
			vim.keymap.set("n", "<leader>gtf", "<cmd>GoTestFunc<CR>")
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("oil").setup({
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = {
					show_hidden = true,
				},
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql" } },
			{ "tpope/vim-dadbod", lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<M-l>",
					clear_suggestion = "<M-[>",
					accept_word = "<M-j>",
				},
				ignore_filetypes = { cpp = true }, -- or { "cpp", }
				color = {
					-- grey
					suggestion_color = "#8a8a8a",
					cterm = 244,
				},
				log_level = "info", -- set to "off" to disable logging completely
				disable_inline_completion = false, -- disables inline completion for use with cmp
				disable_keymaps = false, -- disables built in keymaps for more manual control
				-- condition = function()
				--   return false
				-- end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
			})
		end,
	},
	{
		"ziglang/zig.vim",
	},
	{
		"VPavliashvili/json-nvim",
		config = function()
			vim.keymap.set("n", "<leader>jff", "<cmd>JsonFormatFile<cr>")
			vim.keymap.set("n", "<leader>jmf", "<cmd>JsonMinifyFile<cr>")
			-- autoformat on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("json-nvim", { clear = true }),
				callback = function(ev)
					vim.cmd("JsonFormatFile")
				end,
			})
		end,
	},
	{
		"johmsalas/text-case.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("textcase").setup({})
			require("telescope").load_extension("textcase")
		end,
		keys = {
			"ga", -- Default invocation prefix
		},
		lazy = false,
	},
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
