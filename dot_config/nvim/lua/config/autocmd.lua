vim.api.nvim_create_autocmd({ "TermOpen" }, {
  callback = function()
    vim.opt_local.buflisted = false
    vim.opt_local.cursorline = false
    vim.opt_local.modifiable = true
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.list_contains({ "prompt", "terminal", "nofile" }, vim.bo.buftype) then
      return
    end
    vim.wo.relativenumber = true
    vim.wo.cursorline = true
    vim.wo.cursorcolumn = true
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    vim.wo.relativenumber = false
    vim.wo.cursorline = false
    vim.wo.cursorcolumn = false
  end,
})

vim.cmd("autocmd Filetype go setlocal tabstop=4 shiftwidth=4  noexpandtab")
vim.cmd("autocmd Filetype proto setlocal tabstop=4 shiftwidth=4  noexpandtab")
vim.cmd("autocmd Filetype rust setlocal tabstop=4 shiftwidth=4  expandtab")
vim.cmd("autocmd Filetype python setlocal tabstop=4 shiftwidth=4")
vim.cmd("autocmd Filetype java setlocal tabstop=4 shiftwidth=4")
