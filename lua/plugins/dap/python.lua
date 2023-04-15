local M = {}

local function get_venv_python_path()
  local workspace_folder = vim.fn.getcwd()
  local pyenv_virtual_env = os.getenv "VIRTUAL_ENV"
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

function M.setup()
  local dap = require "dap"

  local debugpy_path = vim.fn.stdpath "data" .. "/mason/bin/debugpy"
  local venv_python_path = get_venv_python_path()

  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
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
      env_python_path = venv_python_path,
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

  dap.adapters.python = {
    type = "executable",
    command = debugpy_path,
    args = {
      "-m",
      "debugpy.adapter",
    },
  }
end

return M
