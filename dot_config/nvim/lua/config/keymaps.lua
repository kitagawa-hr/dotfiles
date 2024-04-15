-- ======================
-- Keymap
-- ======================
-- Doc: https://neovim.io/doc/user/api.html#nvim_set_keymap()

local set_keymap = vim.api.nvim_set_keymap
set_keymap("n", "H", "^", { noremap = true })
set_keymap("v", "H", "^", { noremap = true })
set_keymap("o", "H", "^", { noremap = true })
set_keymap("n", "L", "$", { noremap = true })
set_keymap("v", "L", "$", { noremap = true })
set_keymap("o", "L", "$", { noremap = true })
set_keymap("n", "Y", "y$", { noremap = true })
set_keymap("n", "]b", "<Cmd>bnext<CR>", { noremap = true })
set_keymap("n", "[b", "<Cmd>bprev<CR>", { noremap = true })
set_keymap("v", "p", '"_dP', { noremap = true })
set_keymap("", "<esc><esc>", "<Cmd>nohlsearch<CR>", { noremap = true })

vim.keymap.set("n", "<leader>yf", function()
  vim.fn.setreg("*", vim.fn.expand("%"))
  vim.notify("Yanked relative file path to clipboard", vim.log.levels.INFO)
end, { noremap = true, desc = "Yank relative file path to clipboard" })

vim.keymap.set("n", "<leader>yF", function()
  vim.fn.setreg("*", vim.fn.expand("%:p"))
  vim.notify("Yanked full file path to clipboard", vim.log.levels.INFO)
end, { noremap = true, desc = "Yank full file path to clipboard" })

