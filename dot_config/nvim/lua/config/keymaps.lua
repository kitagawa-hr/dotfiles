-- ======================
-- Keymap
-- ======================
-- Doc: https://neovim.io/doc/user/api.html#nvim_set_keymap()

local set_keymap = vim.api.nvim_set_keymap
set_keymap("n", "gh", "^", { noremap = true })
set_keymap("n", "gl", "$", { noremap = true })
set_keymap("v", "gh", "^", { noremap = true })
set_keymap("v", "gl", "$", { noremap = true })
set_keymap("n", "Y", "y$", { noremap = true })
set_keymap("n", "]b", "<Cmd>bnext<CR>", { noremap = true })
set_keymap("n", "[b", "<Cmd>bprev<CR>", { noremap = true })
set_keymap("v", "p", '"_dP', { noremap = true })
set_keymap("", "<esc><esc>", "<Cmd>nohlsearch<CR>", { noremap = true })

-- Terminal
set_keymap("t", "<esc>", "<C-\\><C-n>", { noremap = true })
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  callback = function()
    vim.opt_local.modifiable = true
    vim.opt_local.number = false
  end,
})
