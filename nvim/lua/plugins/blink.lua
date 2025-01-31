return {
	"saghen/blink.cmp",
	dependencies = "rafamadriz/friendly-snippets",
	version = "*",
	opts = {
		keymap = { preset = "default" },
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		completion = {
			menu = {
				draw = {
					columns = {
						{ "label", "label_description", "kind_icon", gap = 1 },
					},
				},
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		signature = {
			enabled = true,
		},
	},
	opts_extend = { "sources.default" },
}
