return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      picker = {
        sources = {
          buffers = {
            win = {
              input = {
                keys = {
                  ["d"] = "bufdelete",
                },
              },
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<C-u>"] = { "preview_scroll_up", mode = { "n", "v" } },
              ["<C-d>"] = { "preview_scroll_down", mode = { "n", "v" } },
            },
          },
        },
      },
      terminal = {
        env = {
          VIMRUNTIME = vim.env.VIMRUNTIME,
          VIM = vim.env.VIM,
        },
        shell = vim.fn.executable("fish") == 1 and "fish" or vim.opt.shell,
        keys = {
          n_esc = { "<Esc>", "<Plug>(esc)<ESC>", mode = "n" },
          t_esc = { "<Plug>(esc)<ESC>", "i<ESC>", mode = "t" },
        },
      },
    },
	  -- stylua: ignore
    keys = {
      { "<leader>D",  function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>lR", function() Snacks.rename() end, desc = "Rename File" },
      { "]r",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
      { "[r",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
      { "<leader>N",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<D-j>",  function() Snacks.terminal.toggle() end, mode = {"i", "n", "t"}, desc = "Toggle Terminal" },
 			{ "<leader>ge", function() Snacks.lazygit.open() end, desc = "Open Lazygit" },
 			{ "<leader>gl", function() Snacks.lazygit.log() end, desc = "Git Log" },
 			{ "<leader>gL", function() Snacks.lazygit.log_file() end, desc = "Git Log current file" },
			-- pickers
      { "<leader>/",  function() Snacks.picker.lines() end, desc = "search-command" },
      { "<leader>:",  function() Snacks.picker.command_history() end, desc = "Command History" },
 			{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep files" },
      { "<leader>fG", function() Snacks.picker.grep_buffers() end, desc = "Grep buffers" },
 			{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
 			{ "<leader>ft", function() Snacks.picker.explorer() end, desc = "File tree" },
 			{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
 			{ "<leader>fj", function() Snacks.picker.jumps() end, desc = "Find jumps" },
 			{ "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },
 			{ "<leader>fq", function() Snacks.picker.qflist() end, desc = "quickfix" },
 			{ "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
			{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
			{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
			{ "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
			{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
			{ "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    },
  },
}

