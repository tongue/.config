vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "[W]rite Buffer" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "[Q]uickfix Next" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "[Q]uickfix Previous" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
