return {
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#lazynvim
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      ---@diagnostic disable-next-line: missing-fields
      configs.setup({
        highlight = { enable = true },
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "diff",
          "gitignore",
          "go",
          "html",
          "http",
          "java",
          "javascript",
          "json",
          "kotlin",
          "lua",
          "markdown",
          "markdown_inline",
          "nix",
          "php",
          "python",
          "query",
          "regex",
          "rust",
          "scss",
          "sql",
          "toml",
          "typescript",
          "vim",
          "yaml",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "v",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>ns"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>nS"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              ["]o"] = { query = "@loop.*", desc = "Next loop" },
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
              ["[o"] = { query = "@loop.*", desc = "Prev loop" },
              ["[s"] = { query = "@scope", query_group = "locals", desc = "Prev scope" },
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
            },
          },
        },
      })
    end,
  },
  { "williamboman/mason.nvim", config = {} },
  {
    "williamboman/mason-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "folke/neodev.nvim",
    },
    opts = {
      ensure_installed = {
        "efm",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "typos_lsp",
      },
      automatic_installation = true,
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
        lua_ls = function()
          require("neodev").setup({})
          require("lspconfig")["lua_ls"].setup({
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                  pathStrict = true,
                  path = { "?.lua", "?/init.lua" },
                },
                workspace = {
                  library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
                    "${3rd}/luv/library",
                    "${3rd}/busted/library",
                    "${3rd}/luassert/library",
                  }),
                  checkThirdParty = "Disable",
                },
                diagnostics = {
                  globals = { "vim" },
                  undefined_global = false,
                },
              },
            },
          })
        end,
      },
    },
  },
  -- UI
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({})
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    hover = {
      open_link = "gx",
      open_cmd = "!open",
    },
    keys = {
      {
        "]d",
        "<cmd>Lspsaga diagnostic_jump_next<cr>",
        desc = "Next Diagnostic",
      },
      {
        "[d",
        "<cmd>Lspsaga diagnostic_jump_prev<cr>",
        desc = "Prev Diagnostic",
      },
      { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Doc" },
      { "<space>lc", "<cmd>Lspsaga code_action<cr>", desc = "LSP Code Action" },
      { "<space>lf", "<cmd>Lspsaga finder<cr>", desc = "LSP Finder" },
      { "<space>lr", "<cmd>Lspsaga rename<cr>", desc = "LSP Rename" },
      { "<space>lo", "<cmd>Lspsaga outline<cr>", desc = "LSP Outline" },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<lader>xx", "<cmd>TroubleToggle<cr>" },
      { "<lader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>" },
      { "gR", "<cmd>TroubleToggle lsp_references<cr>" },
    },
    opts = {},
  },
  -- formatter
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "=",
        function()
          require("conform").format({ async = true, lsp_fallback = true }, function(err)
            if not err then
              if vim.startswith(vim.api.nvim_get_mode().mode:lower(), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
              end
            end
          end)
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { { "prettierd", "prettier" } },
      },
    },

    format_after_save = { timeout_ms = 5000, lsp_fallback = true },
  },
}
