return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      close_on_exit = true,
      direction = "horizontal",
      open_mapping = "<C-_>",
      insert_mappings = true,
      terminal_mapping = true,
      shell = os.getenv("SHELL"),
      size = 20,
      start_in_insert = true,
      winbar = {
        enabled = true,
        name_formatter = function(term)
          return term.name
        end,
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<C-\\><C-n><Plug>(esc)", { noremap = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<Plug>(esc)<esc>", "i<esc>", { noremap = true, silent = true })
      end,
    },
  },
  {
    "chomosuke/term-edit.nvim",
    ft = "toggleterm",
    version = "1.*",
    opts = {
      prompt_end = "[:❯] ",
    },
  },
}
