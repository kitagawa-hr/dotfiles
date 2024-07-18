local _efm_languages = {
  dockerfile = {
    {
      lintCommand = "hadolint --no-color -",
      lintStdin = true,
      lintFormats = { "-:%l %.%# %trror: %m", "-:%l %.%# %tarning: %m", "-:%l %.%# %tnfo: %m" },
      rootMarkers = { ".hadolint.yaml" },
    },
  },
  json = {
    {
      formatCommand = "jq",
      formatStdin = true,
    },
  },
  javascript = {
    {
      formatCommand = "biome check --apply --stdin-file-path '${INPUT}'",
      formatStdin = true,
      rootMarkers = { "rome.json", "biome.json", "package.json" },
    },
    {
      lintCommand = "biome lint --colors=off --stdin-file-path '${INPUT}'",
      lintStdin = true,
      rootMarkers = { "rome.json", "biome.json", "package.json" },
    },
  },
  typescript = {
    {
      formatCommand = "biome check --apply --stdin-file-path '${INPUT}'",
      formatStdin = true,
      rootMarkers = { "rome.json", "biome.json", "package.json" },
    },
    {
      lintCommand = "biome lint --colors=off --stdin-file-path '${INPUT}'",
      lintStdin = true,
      rootMarkers = { "rome.json", "biome.json", "package.json" },
    },
  },
  lua = {
    {
      formatCanRange = true,
      formatCommand = "stylua --color Never ${--range-start:charStart} ${--range-end:charEnd} -",
      formatStdin = true,
      rootMarkers = { "stylua.toml", ".stylua.toml" },
    },
  },
  python = {
    {
      formatCommand = "ruff format --no-cache --stdin-filename '${INPUT}'",
      formatStdin = true,
      rootMarkers = {
        "pyproject.toml",
        "setup.py",
        "requirements.txt",
        "ruff.toml",
      },
    },
  },
  sh = {
    {
      formatCommand = "shfmt -filename '${INPUT}' -",
      formatStdin = true,
    },
    {
      prefix = "shellcheck",
      lintSource = "shellcheck",
      lintCommand = "shellcheck --color=never --format=gcc -",
      lintIgnoreExitCode = true,
      lintStdin = true,
      lintFormats = { "-:%l:%c: %trror: %m", "-:%l:%c: %tarning: %m", "-:%l:%c: %tote: %m" },
      rootMarkers = {},
    },
  },
  sql = {
    {
      formatCommand = "sql-formatter --config ~/.sql-formatter.json",
      formatStdin = true,
    },
  },
  toml = {
    {
      formatCanRange = true,
      formatCommand = "taplo format -",
      formatStdin = true,
    },
  },
  markdown = {
    {
      lintCommand = "markdownlint -s",
      lintStdin = true,
      lintFormats = {
        "%f:%l %m",
        "%f:%l:%c %m",
        "%f: %l: %m",
      },
    },
  },
  nix = {
    {
      formatCommand = "nixfmt",
      formatStdin = true,
      rootMarkers = {
        "flake.nix",
        "shell.nix",
        "default.nix",
      },
    },
    {
      prefix = "statix",
      lintSource = "statix",
      lintCommand = "statix check --stdin --format=errfmt",
      lintStdin = true,
      lintIgnoreExitCode = true,
      lintFormats = { "<stdin>>%l:%c:%t:%n:%m" },
      rootMarkers = {
        "flake.nix",
        "shell.nix",
        "default.nix",
      },
    },
  },
  yaml = { {
    formatCommand = "yamlfmt -",
    formatStdin = true,
  } },
  zig = { {
    formatCommand = "zig fmt --stdin",
    formatStdin = true,
  } },
}

local efmls_config = {
  cmd = {
    "efm-langserver",
    "-logfile",
    vim.fn.stdpath("log") .. "/efm.log",
    "-loglevel",
    "1",
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = true,
    completion = true,
  },
  filetypes = vim.tbl_keys(_efm_languages),
  settings = {
    rootMarkers = { ".git/" },
    languages = _efm_languages,
  },
}

local function _format_buffer(bufnr)
  local ft = vim.bo[bufnr].filetype
  local efm_formatter_available = _efm_languages[ft] ~= nil
    and not vim.tbl_isempty(vim.tbl_filter(function(tbl)
      return tbl.formatCommand ~= nil
    end, _efm_languages[ft]))
  if efm_formatter_available then
    vim.lsp.buf.format({ bufnr = bufnr, name = "efm", async = true })
  else
    vim.lsp.buf.format({ bufnr = bufnr, async = true })
  end
end

vim.keymap.set({ "n", "x" }, "=", function()
  _format_buffer(0)
end)

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
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "neoconf.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
          -- vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
        end,
      })
      vim.lsp.inlay_hint.enable(true)
    end,
  },
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
    config = function()
      require("lspconfig").sqls.setup({
        on_attach = function(client, bufnr)
          require("sqls").on_attach(client, bufnr)
        end,
      })
    end,
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
    dependencies = {
      { "Bilal2453/luvit-meta" },
    },
    ft = "lua",
    opts = {
      library = {
        "~/projects/my-awesome-lib",
        "lazy.nvim",
        "luvit-meta/library",
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        "LazyVim",
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
      },
    },
  },
  {
    "williamboman/mason-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "neovim/nvim-lspconfig",
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {
          local_settings = ".nvim/neoconf.json",
        },
      },
    },
    opts = {
      ensure_installed = {
        "efm",
        "jdtls",
        "pyright",
        "ruff_lsp",
        "rust_analyzer",
        "typos_lsp",
        "lua_ls",
      },
      automatic_installation = false,
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
        efm = function()
          require("lspconfig").efm.setup(efmls_config)
        end,
        jdtls = function() end, -- Use nvim-jdtls instead
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
    outline = {
      keys = { jump = "<CR>" },
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
      { "<C-k>", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Doc" },
      { "<space>lf", "<cmd>Lspsaga finder<cr>", desc = "LSP Finder" },
      { "<space>lr", "<cmd>Lspsaga rename<cr>", desc = "LSP Rename" },
    },
  },
}
