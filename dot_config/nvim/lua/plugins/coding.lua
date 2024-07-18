return {
  { "junegunn/vim-easy-align" },
  { "MTDL9/vim-log-highlighting" },
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
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_silent_exit = 1
      vim.g.VM_theme = "neon"
      vim.g.VM_maps = {
        ["Find Under"] = "",
        ["Find Subword Under"] = "",
        ["Reselect Last"] = "<leader>mr",
        ["Add Cursor Down"] = "<leader>mj",
        ["Add Cursor Up"] = "<leader>mk",
        ["Visual Cursors"] = "<C-n>",
      }
    end,
  },
  { "tpope/vim-repeat", event = "BufEnter" },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga",
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  },
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
  {
    "stevearc/resession.nvim",
    init = function()
      local resession = require("resession")
      resession.setup({})
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
          end
        end,
        nested = true,
      })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
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
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find current buffer" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", mode = "n" },
      { "<leader>fg", "<cmd>Telescope grep_string<cr>", mode = "v" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>" },
      { "<leader>fh", "<cmd>Telescope frecency<cr>" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>" },
      { "gbb", "<cmd>Telescope buffers<cr>" },
      { "gr", "<cmd>Telescope lsp_references<cr>" },
      { "gi", "<cmd>Telescope lsp_implementations<cr>" },
      { "gd", "<cmd>Telescope lsp_definitions<cr>" },
      { "gy", "<cmd>Telescope lsp_type_definitions<cr>" },
    },
    config = function()
      require("telescope").setup({
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<c-x>"] = "delete_buffer",
              },
              n = {
                ["d"] = "delete_buffer",
              },
            },
          },
        },
        extensions = {
          frecency = {},
          fzf = {},
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
    end,
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
  { "wakatime/vim-wakatime", lazy = false },
}
