local symbols = {
  added = "",
  modified = "",
  removed = "",
  readonly = "",
  error = "",
  warn = "",
  info = "",
  hint = "",
  question = "",
}

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
    config = function()
      require("nightfox").setup({
        options = {
          styles = {
            keywords = "bold",
            variables = "italic",
          },
          colorblind = {
            enable = true,
            simulate_only = false,
            severity = {
              protan = 0.3,
              deutan = 0.9,
              tritan = 0,
            },
          },
        },
        palettes = {
          nightfox = {},
        },
        groups = {
          nightfox = {
            WinSeparator = { fg = "#1679ab" },
          },
        },
      })
      vim.cmd("colorscheme nightfox")
    end,
  },
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    opts = {
      variant = "deuteranopia",
    },
    -- config = function()
    --   vim.cmd([[colorscheme modus]])
    -- end,
  },
  -- statusline, tabline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "gitsigns.nvim" },
    event = "UIEnter",
    opts = {
      globalstatus = true,
      refresh = {
        statusline = 500,
        tabline = 1000,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = {
              added = symbols.added .. " ",
              modified = symbols.modified .. " ",
              removed = symbols.removed .. " ",
            },
            source = function()
              ---@diagnostic disable-next-line: undefined-field
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_c = {
          {
            "filename",
            newfile_status = true,
            path = 1,
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 40,
            symbols = {
              modified = symbols.modified,
              readonly = symbols.readonly,
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
          {

            "macro-recording",
            fmt = function()
              local recording_register = vim.fn.reg_recording()
              if recording_register == "" then
                return ""
              else
                return "Recording @" .. recording_register
              end
            end,
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
  {
    "romgrk/barbar.nvim",
    event = "UIEnter",
    dependencies = {
      "gitsigns.nvim",
      "nvim-web-devicons",
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      icons = {
        buffer_index = true,
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = symbols.error },
          [vim.diagnostic.severity.WARN] = { enabled = false },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = false },
        },
      },
    },
    version = "^1.0.0", -- optional: only update when a new 1.x version is released
    keys = {
      { "gb1", "<cmd>BufferGoto 1<cr>" },
      { "gb2", "<cmd>BufferGoto 2<cr>" },
      { "gb3", "<cmd>BufferGoto 3<cr>" },
      { "gb4", "<cmd>BufferGoto 4<cr>" },
      { "gb5", "<cmd>BufferGoto 5<cr>" },
      { "gb6", "<cmd>BufferGoto 6<cr>" },
      { "gb7", "<cmd>BufferGoto 7<cr>" },
      { "gb8", "<cmd>BufferGoto 8<cr>" },
      { "gb9", "<cmd>BufferGoto 9<cr>" },
      { "gb0", "<cmd>BufferFirst<cr>" },
      { "gb$", "<cmd>BufferLast<cr>" },
      { "]b", "<cmd>BufferNext<cr>" },
      { "[b", "<cmd>BufferPrevious<cr>" },
    },
  },
  {
    "b0o/incline.nvim",
    dependencies = {
      "nvim-web-devicons",
    },
    config = function()
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)

          local function get_diagnostic_label()
            local icons = { error = symbols.error, warn = symbols.warn, info = symbols.info, hint = symbols.hint }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
              end
            end
            if #label > 0 then
              table.insert(label, { "┊ " })
            end
            return label
          end

          return {
            { get_diagnostic_label() },
            { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
            { filename .. " ", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
          }
        end,
      })
    end,
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
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
  },
  {
    "folke/trouble.nvim",
    event = "UIEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-x>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
    keys = {
      { "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>" },
      { "<leader>xD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>" },
      {
        "<leader>ls",
        "<cmd>Trouble symbols toggle focus=false win.position=left<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>lc",
        "<cmd>Trouble lsp_incoming_calls toggle focus=true win.position=left<cr>",
        desc = "LSP Incoming Calls (Trouble)",
      },
      {
        "<leader>lC",
        "<cmd>Trouble lsp_outgoing_calls toggle focus=true win.position=left<cr>",
        desc = "LSP Outgoing Calls (Trouble)",
      },
      { "gR", "<cmd>Trouble lsp toggle focus=true<cr>" },
    },
    opts = {},
  },
}
