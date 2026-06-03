return {
 {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust",
      "lawrence-laz/neotest-zig",
      "nvim-neotest/neotest-jest",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-rust"),
          require("neotest-zig")({ dap = { adapter = "codelldb" } }),
          require("neotest-jest")({
            jestCommand = "pnpm test --",
            jestConfigFile = function(file)
              if string.find(file, "/packages/") then
                return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
              end

              return vim.fn.getcwd() .. "/jest.config.ts"
            end,
            env = { CI = true },
            cwd = function(_)
              return vim.fn.getcwd()
            end,
          }),
        },
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
      }
    end,
    keys = {
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test current File",
      },
      {
        "<leader>tF",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
        end,
        desc = "Debug current File",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Test All",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
    },
  },
}
