return {
	"mfussenegger/nvim-lint",
	config = function()
		vim.diagnostic.config({
			signs = true,
			underline = true,
			update_in_insert = false,
			virtual_text = false,
			severity_sort = true,
		})
		local lint = require("lint")
		lint.linters.sveltecheck = {
			name = "svelte",
			cmd = "sveltecheck",
			stdin = true,
			append_fname = true,
			args = {},
			stream = nil,
			ignore_exitcode = false,
			env = nil,
		}
		lint.linters_by_ft = {
			typescript = { "eslint" },
			typescriptreact = { "eslint" },
			javascript = { "eslint" },
			javascriptreact = { "eslint" },
			lua = { "luacheck" },
		}
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
