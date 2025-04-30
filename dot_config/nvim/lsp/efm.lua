local languages = {
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
  yaml = {
    {
      formatCommand = "yamlfmt -",
      formatStdin = true,
    },
    {
      prefix = "actionlint",
      lintCommand = "[[ ${INPUT} =~ \\.github/ ]] && actionlint -no-color -oneline ${INPUT}",
      lintStdin = false,
      lintFormats = {
        "%f:%l:%c: %.%#: SC%n:%trror:%m",
        "%f:%l:%c: %.%#: SC%n:%tarning:%m",
        "%f:%l:%c: %.%#: SC%n:%tnfo:%m",
        "%f:%l:%c: %m",
      },
      requireMarker = true,
      rootMarkers = { ".github/" },
    },
  },
  zig = { {
    formatCommand = "zig fmt --stdin",
    formatStdin = true,
  } },
  graphql = {
    {
      formatCommand = "prettierd --stdin --stdin-filepath '${INPUT}' ${--range-start:charStart} "
        .. "${--range-end:charEnd} ${--tab-width:tabWidth} ${--use-tabs:!insertSpaces}",
      formatCanRange = true,
      formatStdin = true,
      rootMarkers = {
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.js",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettierrc.json5",
        ".prettierrc.mjs",
        ".prettierrc.cjs",
        ".prettierrc.toml",
        "prettier.config.js",
        "prettier.config.cjs",
        "prettier.config.mjs",
      },
    },
  },
}

---@type vim.lsp.Config
return {
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = true,
    completion = true,
  },
  cmd = {
    "efm-langserver",
    "-logfile",
    vim.fn.stdpath("log") .. "/efm.log",
    "-loglevel",
    "1",
  },
  filetypes = vim.tbl_keys(languages),
  root_markers = { ".git" },
  settings = {
    rootMarkers = { ".git/" },
    languages = languages,
  },
  on_attach = function(_, bufnr)
    -- override format keymap
    local ft = vim.bo[bufnr].filetype
    local efm_formatter_available = languages[ft] ~= nil
      and not vim.tbl_isempty(vim.tbl_filter(function(tbl)
        return tbl.formatCommand ~= nil
      end, languages[ft]))
    if efm_formatter_available then
      vim.keymap.set({ "n", "x" }, "=", function()
        vim.lsp.buf.format({ bufnr = bufnr, name = "efm", async = true })
      end, { buffer = bufnr, remap = false })
    end
  end,
}
