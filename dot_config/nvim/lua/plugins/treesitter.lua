return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    install_dir = vim.fn.stdpath('data') .. '/site',
    config = function()
      -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
      languages = {
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
      }

      -- Install parsers
      require("nvim-treesitter").install(languages)

      -- Start treesitter for installed parsers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = languages,
        callback = function(args)
          vim.treesitter.start(args.buf)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter" },
    init = function()
      vim.g.no_plugin_maps = true
    end,
    opts = {
      select = {
        enable = true,
        lookahead = true,
      },
    },
    keys = {
      -- select
      {
        "af",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
        end,
        mode = { "x", "o" },
      },
      {
        "if",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
        end,
        mode = { "x", "o" },
      },
      {
        "ac",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
        end,
        mode = { "x", "o" },
      },
      {
        "ic",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
        end,
        mode = { "x", "o" },
      },
      -- swap
      {
        "<leader>ns",
        function()
          require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
        end,
        mode = "n",
      },
      {
        "<leader>nS",
        function()
          require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
        end,
        mode = "n",
      },
      -- move
      {
        "]m",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
      },
      {
        "[m",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
      },
      {
        "]]",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
      },
      {
        "[[",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
      },
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      keymaps = {
        useDefaults = true,
        ---@type string[]
        disabledDefaults = { "L" },
      },
    },
  },
}
