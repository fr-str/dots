do
	vim.loader.enable()
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	vim.g.have_nerd_font = true
	vim.o.tabstop = 4
	vim.o.softtabstop = 4
	vim.o.shiftwidth = 4
	vim.o.expandtab = true
	vim.o.smartindent = true
	vim.o.number = true
	vim.o.relativenumber = true
	vim.o.mouse = "a"
	vim.o.showmode = false
	vim.o.breakindent = true
	vim.o.undofile = true
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.o.signcolumn = "yes"
	vim.o.updatetime = 250
	vim.o.timeoutlen = 300
	vim.o.splitright = true
	vim.o.splitbelow = true
	vim.o.inccommand = "split"
	-- vim.o.list = true
	-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
	vim.o.cursorline = true
	vim.o.guicursor = "n-v-c-i:block-cursor"
	vim.o.scrolloff = 15
	vim.o.confirm = true
	vim.schedule(function()
		vim.o.clipboard = "unnamedplus"
	end)

	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
	vim.diagnostic.config({
		update_in_insert = false,
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = { min = vim.diagnostic.severity.WARN } },
		virtual_text = true,
		virtual_lines = false,
		jump = {
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float({
					bufnr = bufnr,
					scope = "cursor",
					focus = false,
				})
			end,
		},
	})
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostic [Q]uickfix" })
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	vim.keymap.set("n", "<leader>ih", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, { desc = "Show [I]nlay [H]ints" })

	vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
	vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
	vim.keymap.set("n", "J", "mzJ`z")
	vim.keymap.set("n", "<C-d>", "<C-d>zz")
	vim.keymap.set("n", "<C-u>", "<C-u>zz")
	vim.keymap.set("n", "n", "nzzzv")
	vim.keymap.set("n", "N", "Nzzzv")
	vim.keymap.set("x", "<leader>p", [["_dP]])
	vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
	vim.keymap.set("n", "<leader>fb", vim.lsp.buf.format)

	local function toggle_tilde_wrap()
		local line = vim.fn.getline(".")
		local text = vim.fn.substitute(line, "^\\s*\\|\\s*$", "", "g")
		if string.find(text, "~") then
			text = string.gsub(text, "~", "")
		else
			text = "~" .. text .. "~"
		end
		vim.fn.setline(".", text)
	end

	vim.keymap.set("n", "<leader>~", toggle_tilde_wrap, { desc = "Toggle ~ wrap" })
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})
end

do
	local function run_build(name, cmd, cwd)
		local result = vim.system(cmd, { cwd = cwd }):wait()
		if result.code ~= 0 then
			local stderr = result.stderr or ""
			local stdout = result.stdout or ""
			local output = stderr ~= "" and stderr or stdout
			if output == "" then
				output = "No output from build command."
			end
			vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
		end
	end
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name = ev.data.spec.name
			local kind = ev.data.kind
			if kind ~= "install" and kind ~= "update" then
				return
			end

			if name == "telescope-fzf-native.nvim" and vim.fn.executable("make") == 1 then
				run_build(name, { "make" }, ev.data.path)
				return
			end

			if name == "LuaSnip" then
				if vim.fn.has("win32") ~= 1 and vim.fn.executable("make") == 1 then
					run_build(name, { "make", "install_jsregexp" }, ev.data.path)
				end
				return
			end

			if name == "nvim-treesitter" then
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				vim.cmd("TSUpdate")
				return
			end
		end,
	})
end

---@param repo string
---@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

-- UI / CORE UX PLUGINS
do
	vim.pack.add({ gh("aktersnurra/no-clown-fiesta.nvim") })
	vim.cmd.colorscheme("no-clown-fiesta")
	vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })

	vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
	require("gitsigns").setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	})
	vim.pack.add({ gh("folke/which-key.nvim") })
	require("which-key").setup({
		{ "<leader>c", group = "[C]ode", hidden = true },
		{ "<leader>d", group = "[D]ocument", hidden = true },
		{ "<leader>r", group = "[R]ename", hidden = true },
		{ "<leader>s", group = "[S]earch", hidden = true },
		{ "<leader>w", group = "[W]orkspace", hidden = true },
	})
	vim.pack.add({ gh("echasnovski/mini.nvim") })
	require("mini.statusline").setup({
		use_icons = vim.g.have_nerd_font,
	})
	require("mini.surround").setup()

	vim.pack.add({ gh("folke/todo-comments.nvim") })
	require("todo-comments").setup({ signs = false })

	vim.pack.add({ gh("chrisgrieser/nvim-chainsaw") })
	local chain = require("chainsaw")
	chain.setup({
		marker = "[dupa]",
		logStatements = {
			variableLog = {
				-- go = 'fmt.Fprintln(config.LogFile,"%s %s: ",%s)',
				-- go = 'log.Trace("{{marker}}",log.Any("{{var}}",{{var}}))',
				go = 'fmt.Println("{{marker}} {{var}}: ",{{var}})',
				-- go = 'l.Println("{{marker}} {{var}}: ",{{var}})',
				zig = 'std.debug.print("{{marker}} {{var}}: {s}\\n",.{{{var}}});',
				-- zig = 'std.log.info("{{marker}} {{var}}: {s}",.{{{var}}});',
			},
			objectLog = {
				go = 'e := json.NewEncoder(os.Stdout)/*{{marker}}*/; e.SetIndent("", " ")/*{{marker}}*/; e.Encode({{var}})/*{{marker}}*/',
				-- go = 'e := json.NewEncoder(lsp.l.Writer())/*{{marker}}*/; e.SetIndent("", " ")/*{{marker}}*/; e.Encode({{var}})/*{{marker}}*/',
				-- go = 'log.Trace("{{marker}}",log.JSON({{var}}))',
				-- go = '/*{{marker}}*/b,_:=json.MarshalIndent({{var}},""," ");fmt.Println(string(b))//[dupa]',
				zig = {
					"var writer = std.fs.File.stdout().writer(&[_]u8{});// {{marker}}",
					"try std.json.Stringify.value({{var}}, .{ .whitespace = .indent_1 }, &writer.interface);// {{marker}}",
				},
			},
		},
	})
	vim.keymap.set({ "n", "v" }, "<leader>ol", chain.objectLog)
	vim.keymap.set({ "n", "v" }, "<leader>vl", chain.variableLog)
	vim.keymap.set({ "n", "v" }, "<leader>rl", chain.removeLogs)
end

-- SEARCH & NAVIGATION
do
	---@type (string|vim.pack.Spec)[]
	local telescope_plugins = {
		gh("nvim-lua/plenary.nvim"),
		gh("nvim-telescope/telescope.nvim"),
		gh("nvim-telescope/telescope-ui-select.nvim"),
	}
	if vim.fn.executable("make") == 1 then
		table.insert(telescope_plugins, gh("nvim-telescope/telescope-fzf-native.nvim"))
	end

	-- NOTE: You can install multiple plugins at once
	vim.pack.add(telescope_plugins)
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

	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "ui-select")

	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
	vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	-- vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set("n", "<leader>sl", builtin.spell_suggest, { desc = "[S]uggest spell)" })
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
	vim.keymap.set("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer" })

	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "[S]earch [N]eovim files" })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
		callback = function(event)
			local buf = event.buf
			vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })
			vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "[G]oto [I]mplementation" })
			vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
			vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Open Document Symbols" })
			vim.keymap.set(
				"n",
				"grt",
				builtin.lsp_type_definitions,
				{ buffer = buf, desc = "[G]oto [T]ype Definition" }
			)
			vim.keymap.set(
				"n",
				"gW",
				builtin.lsp_dynamic_workspace_symbols,
				{ buffer = buf, desc = "Open Workspace Symbols" }
			)
		end,
	})
end
-- LSP
do
	vim.pack.add({ gh("j-hui/fidget.nvim") })
	require("fidget").setup()

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
			map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
			map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client:supports_method("textDocument/documentHighlight", event.buf) then
				local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
					end,
				})
			end

			if client and client:supports_method("textDocument/inlayHint", event.buf) then
				map("<leader>th", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, "[T]oggle Inlay [H]ints")
			end
		end,
	})

	---@type table<string, vim.lsp.Config>
	local servers = {
		clangd = {},
		gopls = {},

		stylua = {}, -- Used to format Lua code

		-- Special Lua Config, as recommended by neovim help docs
		lua_ls = {
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						version = "LuaJIT",
						path = { "lua/?.lua", "lua/?/init.lua" },
					},
					workspace = {
						checkThirdParty = false,
						-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
						--  See https://github.com/neovim/nvim-lspconfig/issues/3189
						library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
							"${3rd}/luv/library",
							"${3rd}/busted/library",
						}),
					},
				})
			end,
			---@type lspconfig.settings.lua_ls
			settings = {
				Lua = {
					format = { enable = false }, -- Disable formatting (formatting is done by stylua)
				},
			},
		},
	}

	vim.pack.add({
		gh("neovim/nvim-lspconfig"),
		gh("mason-org/mason.nvim"),
		gh("mason-org/mason-lspconfig.nvim"),
		gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
	})

	-- Automatically install LSPs and related tools to stdpath for Neovim
	require("mason").setup({})

	-- Ensure the servers and tools above are installed
	--
	-- To check the current status of installed tools and/or manually install
	-- other tools, you can run
	--    :Mason
	--
	-- You can press `g?` for help in this menu.
	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		-- You can add other tools here that you want Mason to install
	})

	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

	for name, server in pairs(servers) do
		vim.lsp.config(name, server)
		vim.lsp.enable(name)
	end

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
end

-- FORMATTING
do
	vim.pack.add({ gh("stevearc/conform.nvim") })
	require("conform").setup({
		notify_on_error = false,
		format_on_save = function(bufnr)
			local enabled_filetypes = {}
			if enabled_filetypes[vim.bo[bufnr].filetype] then
				return { timeout_ms = 500 }
			else
				return nil
			end
		end,
		default_format_opts = {
			lsp_format = "fallback",
		},
		formatters_by_ft = {},
	})

	vim.keymap.set({ "n", "v" }, "<leader>fb", function()
		require("conform").format({ async = true })
	end, { desc = "[F]ormat [b]uffer" })
end

-- AUTOCOMPLETE & SNIPPETS
do
	-- [[ Snippet Engine ]]

	-- NOTE: You can also specify plugin using a version range for its git tag.
	--  See `:help vim.version.range()` for more info
	vim.pack.add({ { src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") } })
	local luasnip = require("luasnip")
	luasnip.setup({})
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

	-- [[ Autocomplete Engine ]]
	vim.pack.add({ { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") } })
	require("blink.cmp").setup({
		keymap = {
			-- <tab>/<s-tab>: move to right/left of your snippet expansion
			-- <c-space>: Open menu or open docs if already open
			-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
			-- <c-e>: Hide menu
			-- <c-k>: Toggle signature help
			preset = "default",
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			-- By default, you may press `<c-space>` to show the documentation.
			-- Optionally, set `auto_show = true` to show the documentation after a delay.
            auto_show = true,
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
		},

		sources = {
			default = { "lsp", "path", "snippets" },
		},

		snippets = { preset = "luasnip" },

		fuzzy = { implementation = "lua" },
		signature = { enabled = true },
	})
end

-- TREESITTER
do
	vim.pack.add({ { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" } })

	-- Ensure basic parsers are installed
	local parsers = {
		"bash",
		"c",
		"diff",
		"html",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		"query",
		"vim",
		"vimdoc",
		"go",
		"zig",
	}
	require("nvim-treesitter").install(parsers)

	---@param buf integer
	---@param language string
	local function treesitter_try_attach(buf, language)
		if not vim.treesitter.language.add(language) then
			return
		end
		vim.treesitter.start(buf, language)

		-- Enable treesitter based folds
		-- For more info on folds see `:help folds`
		-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		-- vim.wo.foldmethod = 'expr'

		local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

		if has_indent_query then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end

	local available_parsers = require("nvim-treesitter").get_available()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local buf, filetype = args.buf, args.match

			local language = vim.treesitter.language.get_lang(filetype)
			if not language then
				return
			end

			local installed_parsers = require("nvim-treesitter").get_installed("parsers")

			if vim.tbl_contains(installed_parsers, language) then
				treesitter_try_attach(buf, language)
			elseif vim.tbl_contains(available_parsers, language) then
				require("nvim-treesitter").install(language):await(function()
					treesitter_try_attach(buf, language)
				end)
			else
				treesitter_try_attach(buf, language)
			end
		end,
	})
end
