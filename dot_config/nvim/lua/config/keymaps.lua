-- ======================
-- Keymap
-- ======================
vim.keymap.set({ "n", "v", "o" }, "H", "^", { noremap = true })
vim.keymap.set({ "n", "v", "o" }, "L", "$", { noremap = true })
vim.keymap.set("n", "Y", "y$", { noremap = true })
vim.keymap.set("v", "p", '"pdP', { noremap = true })
vim.keymap.set("", "<esc><esc>", "<Cmd>nohlsearch<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "x", '"xx', { noremap = true })

vim.keymap.set("n", "<leader>yf", function()
  vim.fn.setreg("*", vim.fn.expand("%"))
  vim.notify("Yanked relative file path to clipboard", vim.log.levels.INFO)
end, { noremap = true, desc = "Yank relative file path to clipboard" })

vim.keymap.set("n", "<leader>yF", function()
  vim.fn.setreg("*", vim.fn.expand("%:p"))
  vim.notify("Yanked full file path to clipboard", vim.log.levels.INFO)
end, { noremap = true, desc = "Yank full file path to clipboard" })
