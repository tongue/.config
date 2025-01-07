return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set("n", "<F12>", ":UndotreeToggle<CR>")
	end,
}
