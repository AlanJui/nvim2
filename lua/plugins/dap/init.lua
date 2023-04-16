return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui" },
    { "theHamsta/nvim-dap-virtual-text" },
    { "nvim-telescope/telescope-dap.nvim" },
    { "jay-babu/mason-nvim-dap.nvim" },
    { "jbyuki/one-small-step-for-vimkind" },
    { "mfussenegger/nvim-dap-python" },
  },
  -- stylua: ignore
  keys = {
    { "<leader>dR", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
    -- { "<leader>dE", function() require("dapui").eval(vim.fn.input "[Expression] > ") end, desc = "Evaluate Input", },
    { "<leader>dC", function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
    { "<leader>dU", function() require("dapui").toggle() end, desc = "Toggle UI", },
    { "<leader>db", function() require("dap").step_back() end, desc = "Step Back", },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
    { "<leader>dd", function() require("dap").disconnect() end, desc = "Disconnect", },
    -- { "<leader>de", function() require("dapui").eval() end, mode = {"n", "v"}, desc = "Evaluate", },
    { "<leader>dg", function() require("dap").session() end, desc = "Get Session", },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables", },
    { "<leader>dS", function() require("dap.ui.widgets").scopes() end, desc = "Scopes", },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over", },
    { "<leader>dp", function() require("dap").pause.toggle() end, desc = "Pause", },
    { "<leader>dq", function() require("dap").close() end, desc = "Quit", },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
    { "<leader>ds", function() require("dap").continue() end, desc = "Start", },
    { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
    { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate", },
    { "<leader>du", function() require("dap").step_out() end, desc = "Step Out", },
  },
  config = function()
    require("nvim-dap-virtual-text").setup({
      commented = true,
    })
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup({})

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    local function get_venv_python_path()
      local workspace_folder = vim.fn.getcwd()
      local pyenv_virtual_env = os.getenv("VIRTUAL_ENV")
      local python_path = pyenv_virtual_env .. "/bin/python"

      if vim.fn.executable(workspace_folder .. "/.venv/bin/python") then
        return workspace_folder .. "/.venv/bin/python"
      elseif vim.fn.executable(workspace_folder .. "/venv/bin/python") then
        return workspace_folder .. "/venv/bin/python"
      elseif vim.fn.executable(python_path) then
        return python_path
      else
        return "/usr/bin/python"
      end
    end

    local venv_python_path = get_venv_python_path()
    local debugpy_python_path = vim.fn.stdpath("data") .. "/mason/bin/python"

    require("mason-nvim-dap").setup({
      ensure_installed = { "stylua", "jq" },
      handlers = {
        function(source_name)
          require("mason-nvim-dap.automatic_setup")(source_name)
        end,
        python = function(config)
          config.addapters = {
            type = "executable",
            command = debugpy_python_path,
            args = { "-m", "debugpy.adapter" },
          }

          -- require("mason-nvim-dap").default_setup(config)
          config.configuration = {
            {
              type = "python",
              request = "launch",
              name = "Launch file",
              program = "${file}", -- This configuration will launch the current file if used.
              pythonPath = venv_python_path,
            },
            {
              type = "python",
              request = "launch",
              name = "Launch Django Server",
              cwd = "${workspaceFolder}",
              program = "${workspaceFolder}/manage.py",
              args = {
                "runserver",
                "--noreload",
              },
              console = "integratedTerminal",
              justMyCode = true,
              pythonPath = venv_python_path,
            },
            {
              type = "python",
              request = "launch",
              name = "Python: Django Debug Single Test",
              -- pythonPath = venv_python_path,
              pythonPath = "${workspaceFolder}/.venv/bin/python",
              program = "${workspaceFolder}/manage.py",
              args = {
                "test",
                "${relativeFileDirname}",
              },
              django = true,
              console = "integratedTerminal",
            },
          }
        end,
      },
    })
  end,
}
