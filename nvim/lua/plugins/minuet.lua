vim.pack.add({ "https://github.com/milanglacier/minuet-ai.nvim" })
require("minuet").setup({
	virtualtext = {
		auto_trigger_ft = {},
		auto_trigger_ignore_ft = { "*" },
		keymap = {
			-- accept whole completion
			accept = nil,
			-- accept one line
			accept_line = "<C-l>",
			-- accept n lines (prompts for number)
			-- e.g. "A-z 2 CR" will accept 2 lines
			accept_n_lines = "<A-z>", -- Cycle to prev completion item, or manually invoke completion
			prev = "<A-[>",
			-- Cycle to next completion item, or manually invoke completion
			next = "<C-h>",
			dismiss = "<C-j>",
		},
	},

	provider = "openai_fim_compatible",
	context_window = 16000,
	context_ratio = 0.75,
	n_completions = 1,
	provider_options = {
		openai_fim_compatible = {
			-- For Windows users, TERM may not be present in environment variables.
			-- Consider using APPDATA instead.
			api_key = "TERM",
			name = "Ollama",
			end_point = "http://localhost:11434/v1/completions",
			model = "qwen2.5-coder:7b",
			optional = {
				num_ctx = 8192,
				max_tokens = 40,
				temperature = 0.2,
				stop = { "\n" },
				top_p = 0.9,
			},
		},
	},
})
