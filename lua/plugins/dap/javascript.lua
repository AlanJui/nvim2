local ok, dap_adapter = pcall(require, "dap-vscode-js")
if not ok then
  return
end

local M = {}

function M.setup()
  local dap = require("dap")

  dap_adapter.setup({
    -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- node_path = node_path,
    -- Path to vscode-js-debug installation.
    -- debugger_path = debugger_path,
    -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    -- debugger_cmd = debugger_cmd,
    -- which adapters to register in nvim-dap
    -- adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    adapters = { "pwa-node", "pwa-chrome" },
    -- Path for file logging
    -- log_file_path = vim.fn.stdpath("cache") .. "/debug_adapter.log",
    -- Logging level for output to console. Set to false to disable console output.
    -- log_console_level = vim.log.levels.ERROR,
    -- log_console_level = vim.log.levels.DEBUG,
  })

  for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
      {
        name = "Launch Chrome",
        type = "pwa-chrome",
        request = "launch",
        url = "http://localhost:8080",
        webRoot = "${workspaceFolder}",
      },
      {
        name = "Launch file",
        type = "pwa-node",
        request = "launch",
        program = "${file}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
      },
      {
        name = "Attach",
        type = "pwa-node",
        request = "attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
      },
      {
        name = "Launch Program",
        type = "pwa-node",
        request = "launch",
        skipFiles = {
          "<node_internals>/**",
        },
        program = "${workspaceFolder}/bin/www",
        console = "integratedTerminal",
      },
      {
        name = "Launch app.js",
        type = "pwa-node",
        request = "launch",
        skipFiles = {
          "<node_internals>/**",
        },
        program = "${workspaceFolder}/app.js",
        console = "integratedTerminal",
      },
    }
  end
end

return M
