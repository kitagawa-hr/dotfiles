return {
  { "easymotion/vim-easymotion", event = "BufEnter" },
  { "junegunn/vim-easy-align" },
  { "machakann/vim-highlightedyank", event = "BufEnter" },
  {
    "numToStr/Comment.nvim",
    event = "BufEnter",
    opts = {
      mappings = {
        basic = false,
        extra = false,
      },
    },
    keys = {
      { "<leader>cc", "<Plug>(comment_toggle_linewise_current)", mode = "n", desc = "Toggle current line comment" },
      { "<leader>cb", "<Plug>(comment_toggle_blockwise_current)", mode = "n", desc = "Toggle current block comment" },
      { "<leader>cc", "<Plug>(comment_toggle_linewise_visual)", mode = "x", desc = "Toggle visual line comment" },
      { "<leader>cb", "<Plug>(comment_toggle_blockwise_visual)", mode = "x", desc = "Toggle visual block comment" },
    },
  },
  { "mg979/vim-visual-multi" },
  { "tpope/vim-repeat", event = "BufEnter" },
  { "tpope/vim-surround", event = "BufEnter" },
  { "arthurxavierx/vim-caser", event = "BufEnter" },
  {
    "pocco81/auto-save.nvim",
    event = { "InsertEnter", "TextChanged" },
    opts = {
      execution_message = {
        message = function()
          return ""
        end,
      },
      trigger_events = { "InsertLeave" },
    },
  },
  {
    "tversteeg/registers.nvim",
    event = "BufEnter",
    name = "registers",
    keys = {
      { '"', mode = { "n", "v" } },
      { "<C-R>", mode = "i" },
    },
    cmd = "Registers",
  },
  -- git
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    opts = {
      signcolumn = true,
    },
    keys = {
      {
        "]c",
        function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            require("gitsigns").next_hunk()
          end)
          return "<Ignore>"
        end,
        desc = "Next Changed Hunk",
      },
      {
        "[c",
        function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            require("gitsigns").prev_hunk()
          end)
          return "<Ignore>"
        end,
        desc = "Prev Changed Hunk",
      },
    },
  },
  { "tpope/vim-fugitive" },
  { "rhysd/git-messenger.vim" },
  -- session
  {
    "rmagatti/auto-session",
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    },
    init = function()
      -- https://github.com/rmagatti/auto-session/issues/223
      local autocmd = vim.api.nvim_create_autocmd

      local lazy_did_show_install_view = false

      local function auto_session_restore()
        -- important! without vim.schedule other necessary plugins might not load (eg treesitter) after restoring the session
        vim.schedule(function()
          require("auto-session").AutoRestoreSession()
        end)
      end

      autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          local lazy_view = require("lazy.view")

          if lazy_view.visible() then
            -- if lazy view is visible do nothing with auto-session
            lazy_did_show_install_view = true
          else
            -- otherwise load (by require'ing) and restore session
            auto_session_restore()
          end
        end,
      })

      autocmd("WinClosed", {
        pattern = "*",
        callback = function(ev)
          local lazy_view = require("lazy.view")

          -- if lazy view is currently visible and was shown at startup
          if lazy_view.visible() and lazy_did_show_install_view then
            -- if the window to be closed is actually the lazy view window
            if ev.match == tostring(lazy_view.view.win) then
              lazy_did_show_install_view = false
              auto_session_restore()
            end
          end
        end,
      })
    end,
  },
  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", mode = "n" },
      { "<leader>fg", "<cmd>Telescope grep_string<cr>", mode = "v" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>" },
      { "<leader>fh", "<cmd>Telescope frecency<cr>" },
      { "gr", "<cmd>Telescope lsp_references<cr>" },
      { "gi", "<cmd>Telescope lsp_implementations<cr>" },
      { "gd", "<cmd>Telescope lsp_definitions<cr>" },
      { "gy", "<cmd>Telescope lsp_type_definitions<cr>" },
    },
    opts = {
      extensions = {
        frecency = {},
      },
    },
  },
  -- file manager
  {
    "DreamMaoMao/yazi.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>fe", "<cmd>Yazi<CR>", desc = "Open file explorer (yazi)" },
    },
  },
  -- Mark
  {
    "chentoast/marks.nvim",
    opts = {
      builtin_marks = { "." },
      mappings = {
        set_next = "m,",
        next = "m]",
        prev = "m[",
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  -- Terminal
  {
    "numToStr/FTerm.nvim",
    keys = {
      { "n", "<leader>t", "<CMD>lua require('FTerm').toggle()<CR>" },
    },
  },
}
