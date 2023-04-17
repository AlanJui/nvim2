local ok, dap_adapter = pcall(require, "dap-vscode-js")
if not ok then
  return
end

local M = {}

function M.setup()
  local dap = require("dap")

  dap_adapter.setup({
    -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
    debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
    -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
    -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
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
