return {
	"mhartington/formatter.nvim",
	dependencies = {
		"tpope/vim-sleuth",
	},
	config = function()
		-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
		local formatter = require("formatter")
		formatter.setup({
			logging = true,
			log_level = vim.log.levels.WARN,
			filetype = {
				-- Formatter configurations for filetype "lua" go here
				-- and will be executed in order
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				html = {
					require("formatter.filetypes.html").prettier,
				},
				svelte = {
					require("formatter.filetypes.svelte").prettier,
				},
				javascript = {
					require("formatter.filetypes.javascript").prettier,
				},
				typescript = {
					function()
						local cwd = vim.fn.getcwd()
						local is_deno = vim.fn.filereadable(cwd .. "/deno.json") == 1
							or vim.fn.filereadable(cwd .. "/deno.jsonc") == 1

						if is_deno then
							return require("formatter.filetypes.typescript").denofmt()
						else
							return require("formatter.filetypes.typescript").prettier()
						end
					end,
				},
				typescriptreact = {
					require("formatter.filetypes.typescriptreact").prettier,
				},
				json = {
					require("formatter.filetypes.json").prettier,
				},
				css = {
					require("formatter.filetypes.css").prettier,
				},
				markdown = {
					require("formatter.filetypes.markdown").prettier,
				},
				rust = {
					require("formatter.filetypes.rust").rustfmt,
				},
				go = {
					require("formatter.filetypes.go").gofmt,
				},
				templ = {
					vim.lsp.buf.format(),
				},
				dart = {
					require("formatter.filetypes.dart").dartformat,
				},
				cpp = {
					require("formatter.filetypes.cpp").clangformat,
				},
				["*"] = {
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
			},
		})
		vim.keymap.set("n", "<leader>f", "<cmd>FormatWrite<cr>", { desc = "Format buffer" })
	end,
}
