vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ======================
-- Appearance
-- ======================
vim.opt.filetype = "on"
vim.opt.termguicolors = true

-- ======================
-- Editor
-- ======================

-- Coding
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.smartindent = true
vim.bo.spelllang = "en_us"
vim.bo.syntax = "ON"
vim.bo.tabstop = 2
vim.cmd([[set clipboard^=unnamedplus]])
vim.opt.shell = "zsh"
vim.opt.showmatch = true
vim.opt.virtualedit = "all"
vim.wo.cursorcolumn = true
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.spell = true

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

-- Command line
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.cmdheight = 0

-- Status line
vim.opt.laststatus = 3
vim.opt.showcmd = true

-- Misc
vim.opt.compatible = false
vim.opt.visualbell = true
vim.opt.exrc = true

-- Grep
vim.opt.grepprg = "rg --vimgrep"
-- Autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
})


