return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = "",
			section_separators = "",
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = { { "filename", path = 1 } },
			lualine_x = { "diagnostics", "diff" },
			lualine_y = { "location", "progress" },
			lualine_z = { "encoding", "fileformat", "filetype" },
		},
	},
}
