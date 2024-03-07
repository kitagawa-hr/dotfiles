return {
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      local api = vim.api

      local exclude_ft = { "help", "git", "markdown", "snippets", "text", "gitconfig", "alpha", "dashboard" }

      require("ibl").setup({
        indent = {
          -- -- U+2502 may also be a good choice, it will be on the middle of cursor.
          -- -- U+250A is also a good choice
          char = "▏",
        },
        scope = {
          show_start = false,
          show_end = false,
        },
        exclude = {
          filetypes = exclude_ft,
          buftypes = { "terminal" },
        },
      })

      local gid = api.nvim_create_augroup("indent_blankline", { clear = true })
      api.nvim_create_autocmd("InsertEnter", {
        pattern = "*",
        group = gid,
        command = "IBLDisable",
      })

      api.nvim_create_autocmd("InsertLeave", {
        pattern = "*",
        group = gid,
        callback = function()
          if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
            vim.cmd([[IBLEnable]])
          end
        end,
      })
    end,
  },
  -- resources
  { "ryanoasis/vim-devicons" },
  { "nvim-tree/nvim-web-devicons" },
  -- themes
  { "folke/tokyonight.nvim" },
  { "romainl/vim-dichromatic" },
  { "patstockwell/vim-monokai-tasty" },
  { "phanviet/vim-monokai-pro" },
  {
    "EdenEast/nightfox.nvim",
    -- config = function()
    --   vim.cmd([[colorscheme nightfox]])
    -- end,
    opts = {
      pallettes = {
        all = {
          red = "#cc3311",
          green = "#228833",
          yellow = "#ccbb44",
          blue = "#0077bb",
          magenta = "#ee3377",
          cyan = "#33bbee",
          orange = "#ee7733",
          --pink    = ""
        },
      },
    },
  },
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    opts = {
      variant = "deuteranopia",
    },
    config = function()
      vim.cmd([[colorscheme modus]])
    end,
  },
  -- statusline, tabline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "UIEnter",
    opts = {
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            sources = { "nvim_diagnostic", "nvim_lsp" },
            sections = { "error", "warn", "info", "hint" },
            diagnostics_color = {
              error = "DiagnosticError",
              warn = "DiagnosticWarn",
              info = "DiagnosticInfo",
              hint = "DiagnosticHint",
            },
            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
            colored = true,
            update_in_insert = false,
            always_visible = false,
          },
        },
        lualine_c = {
          {
            "buffers",
            show_filename_only = true,
            hide_filename_extension = false,
            show_modified_status = true,

            mode = 2,
            -- 0: Shows buffer name
            -- 1: Shows buffer index
            -- 2: Shows buffer name + buffer index
            -- 3: Shows buffer number
            -- 4: Shows buffer name + buffer number

            max_length = vim.o.columns * 2 / 3,
            filetype_names = {
              TelescopePrompt = "Telescope",
            },
            use_mode_colors = false,
            symbols = {
              modified = " ●",
              alternate_file = "#",
              directory = "",
            },
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
    keys = {
      { "gb1", "<cmd>LualineBuffersJump! 1<cr>" },
      { "gb2", "<cmd>LualineBuffersJump! 2<cr>" },
      { "gb3", "<cmd>LualineBuffersJump! 3<cr>" },
      { "gb4", "<cmd>LualineBuffersJump! 4<cr>" },
      { "gb5", "<cmd>LualineBuffersJump! 5<cr>" },
      { "gb6", "<cmd>LualineBuffersJump! 6<cr>" },
      { "gb7", "<cmd>LualineBuffersJump! 7<cr>" },
      { "gb8", "<cmd>LualineBuffersJump! 8<cr>" },
      { "gb9", "<cmd>LualineBuffersJump! 9<cr>" },
      { "gb$", "<cmd>LualineBuffersJump! $<cr>" },
    },
  },
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {},
    version = "^1.0.0",
  },
  {
    "folke/which-key.nvim",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },
}
