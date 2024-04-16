return {
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
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },
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
      current_line_blame = true,
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
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "telescope.nvim",
    },
    config = true,
  },
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
    },
    config = function()
      vim.api.nvim_create_user_command("Browse", function(opts)
        vim.fn.system({ "open", opts.fargs[1] })
      end, { nargs = 1 })
    end,
    keys = {
      { "<leader>go", "<cmd>GBrowse<cr>", desc = "Open git repo in browser", mode = { "n", "v" } },
      { "<leader>yg", "<cmd>GBrowse!<cr>", desc = "Yank git repo url to clipboard", mode = { "n", "v" } },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      { "<leader>gd", "<cmd>Git diff<cr>", desc = "Git diff" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git log" },
      {
        "<leader>gl",
        function()
          local lines = vim.fn.line("v") .. "," .. vim.fn.line(".")
          vim.cmd.Git("log -L " .. lines .. ":%")
        end,
        desc = "Git log for selected lines",
        mode = { "v" },
      },
      { "<leader>gL", "<cmd>Git log %<cr>", desc = "Git log for buffer" },
    },
  },
  { "rhysd/git-messenger.vim" },
  { "sindrets/diffview.nvim" },
  -- session
  {
    "rmagatti/auto-session",
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
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
      { "<leader>gs", "<cmd>Telescope git_status<cr>" },
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
  -- Move
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      label = {
        rainbow = {
          enabled = true,
          -- number between 1 and 9
          shade = 5,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flafh",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
    },
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {},
    keys = {
      { "gk", "<cmd>HopWordBC<cr>", mode = { "n", "v" } },
      { "gj", "<cmd>HopWordAC<cr>", mode = { "n", "v" } },
      { "M", "<cmd>HopNodes<cr>", mode = { "n", "v" } },
    },
  },
}
