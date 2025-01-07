return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
		"folke/neodev.nvim",
		'saghen/blink.cmp',
		{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },
	},
	config = function()
		local mason = require("mason")
		local lspconfig = require("mason-lspconfig")
		local neodev = require("neodev")
		local lspconfig_util = require("lspconfig.util")
		local blink = require("blink.cmp");

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = blink.get_lsp_capabilities(capabilities)

		local servers = {
			html = { filetypes = { "html", "twig", "hbs" } },
			rust_analyzer = {},
			clangd = {},
			ts_ls = {},
			denols = {},
			eslint = {},
			tailwindcss = {},
			css_variables = {},
			ast_grep = {},
			svelte = {},
			templ = {},
			gopls = {},
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		}

		local on_attach = function(_, bufnr)
			local nmap = function(keys, func, desc)
				if desc then
					desc = "LSP: " .. desc
				end

				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end

			nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

			nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
			nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
			nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
			nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
			nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

			-- See `:help K` for why this keymap
			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

			-- Lesser used LSP functionality
			nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
			nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
			nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
			nmap("<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, "[W]orkspace [L]ist Folders")

			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
				vim.lsp.buf.format()
			end, { desc = "Format current buffer with LSP" })
		end
		local deepest_root_pattern = function(patterns1, patterns2)
			local find_root1 = lspconfig_util.root_pattern(unpack(patterns1))
			local find_root2 = lspconfig_util.root_pattern(unpack(patterns2))

			return function(startpath)
				local path1 = find_root1(startpath)
				local path2 = find_root2(startpath)

				if path1 and path2 then
					local path1_length = select(2, path1:gsub("/", ""))
					local path2_length = select(2, path2:gsub("/", ""))

					if path1_length > path2_length then
						return path1
					end
				elseif path1 then
					return path1
				end

				return nil
			end
		end

		neodev.setup()
		mason.setup()

		lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
		})

		lspconfig.setup_handlers({
			function(server_name)
				local nvim_lsp = require("lspconfig")
				if server_name == "denols" then
					nvim_lsp[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
						root_dir = deepest_root_pattern(
							{ "deno.json", "deno.jsonc", "import_map.json" },
							{ "package.json", "tsconfig.json" }
						),
					})
				elseif server_name == "ts_ls" or server_name == "svelte" then
					nvim_lsp[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
						root_dir = deepest_root_pattern(
							{ "package.json", "tsconfig.json" },
							{ "deno.json", "deno.jsonc", "import_map.json" }
						),
						single_file_support = false,
					})
				else
					nvim_lsp[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
					})
				end
			end,
		})
	end,
}
