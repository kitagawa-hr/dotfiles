---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "igorlfs/nvim-dap-view", opts = {} },
    },
    config = function()
      local dap, dv = require("dap"), require("dap-view")
      dap.listeners.before.attach["dap-view-config"] = function()
        dv.open()
      end
      dap.listeners.before.launch["dap-view-config"] = function()
        dv.open()
      end
      dap.listeners.before.event_terminated["dap-view-config"] = function()
        dv.close()
      end
      dap.listeners.before.event_exited["dap-view-config"] = function()
        dv.close()
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.env.HOME .. "/.nix-profile/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb",
          args = { "--port", "${port}" },
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Breakpoint Condition", },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args", },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)", },
      { "<leader>dj", function() require("dap").down() end, desc = "Down", },
      { "<leader>dk", function() require("dap").up() end, desc = "Up", },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last", },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out", },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over", },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate", },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause", },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
      { "<leader>ds", function() require("dap").session() end, desc = "Session", },
    },
  },
}
