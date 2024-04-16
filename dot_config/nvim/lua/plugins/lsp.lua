local _efm_languages = {
  dockerfile = {
    {
      lintCommand = "hadolint --no-color -",
      lintStdin = true,
      lintFormats = { "-:%l %.%# %trror: %m", "-:%l %.%# %tarning: %m", "-:%l %.%# %tnfo: %m" },
      rootMarkers = { ".hadolint.yaml" },
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
      lintCommand = "shellcheck -f gcc -x",
      lintSource = "shellcheck",
      lintFormats = {
        "%f:%l:%c: %t%*[^:]: %m [SC%n]",
      },
    },
  },
  sql = {
    {
      formatCommand = "sql-formatter --config .sql-formatter.json",
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
  },
  yaml = { {
    formatCommand = "yamlfmt -",
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
        end,
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local config = {
        cmd = {
          "jdtls",
          "-Xms2G",
          "-Xmx4G",
        },
        root_dir = vim.fs.dirname(
          vim.fs.find({ ".gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }, { upward = true })[1]
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
    "williamboman/mason-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "neovim/nvim-lspconfig",
      "folke/neodev.nvim",
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
        "lua_ls",
        "pyright",
        "ruff_lsp",
        "rust_analyzer",
        "typos_lsp",
      },
      automatic_installation = false,
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
      { "<space>lc", "<cmd>Lspsaga code_action<cr>", desc = "LSP Code Action" },
      { "<space>lf", "<cmd>Lspsaga finder<cr>", desc = "LSP Finder" },
      { "<space>lr", "<cmd>Lspsaga rename<cr>", desc = "LSP Rename" },
      { "<space>lo", "<cmd>Lspsaga outline<cr>", desc = "LSP Outline" },
    },
  },
}
