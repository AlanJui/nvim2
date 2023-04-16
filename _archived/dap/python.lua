return function(config)
  local function get_venv_python_path()
    local workspace_folder = vim.fn.getcwd()

    if vim.fn.executable(workspace_folder .. "/.venv/bin/python") then
      return workspace_folder .. "/.venv/bin/python"
    elseif vim.fn.executable(workspace_folder .. "/venv/bin/python") then
      return workspace_folder .. "/venv/bin/python"
    elseif vim.fn.executable(os.getenv("VIRTUAL_ENV") .. "/bin/python") then
      return os.getenv("VIRTUAL_ENV" .. "/bin/python")
    else
      return "/usr/bin/python"
    end
  end

  local venv_python_path = get_venv_python_path()
  local debugpy_python_path = vim.fn.stdpath("data") .. "/mason/bin/debugpy"

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
end
