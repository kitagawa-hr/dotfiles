vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
vim.opt.filetype = "on"
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Command line
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.cmdheight = 0

-- Status line
vim.opt.laststatus = 3
vim.opt.showcmd = true

-- Coding
vim.bo.expandtab = true
vim.bo.smartindent = true
vim.bo.spelllang = "en_us"
vim.bo.syntax = "ON"
vim.cmd([[set clipboard^=unnamedplus]])
vim.opt.shell = "zsh"
vim.opt.shiftwidth = 2
vim.opt.showmatch = true
vim.opt.tabstop = 2
vim.opt.virtualedit = "all"
vim.wo.cursorcolumn = true
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.spell = false

-- File
vim.opt.autoread = true
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.opt.fenc = "utf-8"
vim.opt.hidden = true
vim.opt.swapfile = false

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.grepprg = "rg --vimgrep"

-- Misc
vim.opt.compatible = false
vim.opt.visualbell = true
vim.opt.exrc = true

-- Autocmds
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

vim.g.clipboard = {
  name = "orb",
  copy = { ["+"] = { "pbcopy" }, ["*"] = { "pbcopy" } },
  paste = { ["+"] = { "pbpaste" }, ["*"] = { "pbpaste" } },
  cache_enabled = true,
}

vim.cmd("autocmd Filetype go setlocal tabstop=4 shiftwidth=4  noexpandtab")
vim.cmd("autocmd Filetype proto setlocal tabstop=4 shiftwidth=4  noexpandtab")
vim.cmd("autocmd Filetype rust setlocal tabstop=4 shiftwidth=4  expandtab")
vim.cmd("autocmd Filetype python setlocal tabstop=4 shiftwidth=4")
vim.cmd("autocmd Filetype java setlocal tabstop=4 shiftwidth=4")
