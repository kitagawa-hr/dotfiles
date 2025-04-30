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
    opts = {
      prefix = "<leader>C",
    },
    keys = { "<leader>C" },
    cmd = {
      "Subs",
      "TextCaseStartReplacingCommand",
    },
    lazy = false,
  },
  {
    "okuuva/auto-save.nvim",
    version = "^1.0.0",
    event = { "InsertEnter", "TextChanged" },
    opts = {
      event = { "InsertLeave", "TextChanged" },
      debounce_delay = 500,
      condition = function(buf)
        -- don't save for special-buffers
        if vim.fn.getbufvar(buf, "&buftype") ~= "" then
          return false
        end
        return true
      end,
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
            require("gitsigns").nav_hunk("next")
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
            require("gitsigns").nav_hunk("prev")
          end)
          return "<Ignore>"
        end,
        desc = "Prev Changed Hunk",
      },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Git reset Hunk" },
      { "<leader>gm", "<cmd>Gitsigns blame_line<cr>", desc = "Git message" },
    },
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
  -- file manager
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>f.", "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
      { "<leader>fe", "<cmd>Yazi toggle<cr>", desc = "Toggle yazi" },
      { "<leader>fE", "<cmd>Yazi cwd<cr>", desc = "Open yazi in cwd" },
      {
        "<leader>fl",
        function()
          local log_dir = vim.fn.stdpath("log") --[[@as string]]
          require("yazi").yazi({}, log_dir)
        end,
        desc = "Open yazi in log directory",
      },
    },
    opts = {
      keymaps = {
        open_file_in_vertical_split = "<C-v>",
        open_file_in_horizontal_split = "<C-s>",
      },
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
    opts = {
      check_ts = true,
    },
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
      { "ga", "<cmd>HopNodes<cr>", mode = { "n", "v" } },
    },
  },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust",
      "lawrence-laz/neotest-zig",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-rust"),
          require("neotest-zig")({ dap = { adapter = "codelldb" } }),
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
		---@diagnostic disable-next-line: missing-fields
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap"}) end, desc = "Debug Nearest" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = "markdown",
    event = { "BufReadPre " .. vim.fn.expand("~") .. "/obsidian/**.md" },
    dependencies = {
      "plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "private",
          path = vim.fn.expand("~") .. "/obsidian/private",
        },
      },
    },
  },
  {
    "monaqa/dial.nvim",
    dependencies = { "plenary.nvim" },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal_int,
          augend.date.alias["%Y-%m-%d"],
          augend.constant.alias.bool,
          augend.constant.new({ elements = { "True", "False" }, word = true, cyclic = true }),
          augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
          augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
          augend.constant.new({ elements = { "==", "!=" }, word = false, cyclic = true }),
        },
      })
    end,
    -- stylua: ignore
    keys = {
      { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end },
      { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end },
      { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode="v" },
      { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode="v" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode="v" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode="v" },
    },
  },
  {
    "otavioschwanck/arrow.nvim",
    dependencies = { "mini.icons" },
    opts = {
      show_icons = true,
      leader_key = "M",
      buffer_leader_key = "m",
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      picker = {},
      terminal = {},
      lazygit = {},
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      gitbrowse = {
        what = "file",
      },
      words = { enabled = true },
      styles = {
        ---@diagnostic disable-next-line: missing-fields
        notification = {
          wo = { wrap = true }, -- Wrap notifications
        },
      },
      indent = {
        enabled = true,
        filter = function(buf)
          local exclude_filetypes = { "help", "git", "markdown", "snippets", "text", "gitconfig" }
          return not vim.tbl_contains(exclude_filetypes, vim.bo[buf].filetype) and vim.bo[buf].buftype == ""
        end,
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
 			{ "<leader>ge", function() Snacks.lazygit() end, desc = "Open Lazygit" },
			-- pickers
      { "<leader>/",  function() Snacks.picker.lines() end, desc = "search-command" },
      { "<leader>:",  function() Snacks.picker.command_history() end, desc = "Command History" },
 			{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep files" },
      { "<leader>fG", function() Snacks.picker.grep_buffers() end, desc = "Grep buffers" },
 			{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
 			{ "<leader>ft", function() Snacks.picker.explorer() end, desc = "File tree" },
 			{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
 			{ "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },
 			{ "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
			{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
			{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
			{ "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
			{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
			{ "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    },
  },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    },
		-- stylua: ignore
    keys = {
      { "<leader>q", function() require("quicker").toggle() end, desc = "Toggle quickfix" },
      { "<leader>l", function() require("quicker").toggle({ loclist = true }) end, desc = "Toggle loclist" },
    },
  },
}
