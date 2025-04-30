return {
  -- Treesitter
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
          "nu",
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
          "vimdoc",
          "yaml",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "+",
            node_incremental = "+",
            node_decremental = "-",
            scope_incremental = false,
          },
        },
      })
    end,
    dependencies = {
      "nushell/tree-sitter-nu",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter" },
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
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
            },
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config({ virtual_lines = true })
      vim.lsp.enable({
        "basedpyright",
        "efm",
        "lua_ls",
        "nil_ls",
        "rust_analyzer",
        "sqls",
        "ts_ls",
        "zls",
      })
      vim.g.zig_fmt_autosave = 0
      vim.keymap.set({ "n", "x" }, "=", function()
        vim.lsp.buf.format({ async = true })
      end)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          local bufnr = args.buf
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
          -- set key mappings
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        end,
      })
    end,
  },
  -- Language specific configs
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local config_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
      local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
      local config = {
        cmd = {
          "jdtls",
          "-Xms2G",
          "-Xmx4G",
          "-data",
          workspace_dir,
          "-configuration",
          config_dir,
        },
        root_dir = vim.fs.dirname(
          vim.fs.find({ ".git", "mvnw", "pom.xml", "build.gradle", ".gradlew" }, { upward = true })[1]
        ),
        settings = {
          java = {
            signatureHelp = { enabled = true },
          },
        },
      }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          require("jdtls").start_or_attach(config)
        end,
      })
    end,
  },
  {
    "nanotee/sqls.nvim",
    ft = "sql",
    keys = {
      {
        "X",
        "<Plug>(sqls-execute-query)",
        mode = { "n", "x" },
        ft = "sql",
        desc = "Sqls Execute Query",
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
}
