return {
  -- add LSP Server  to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed
        -- with mason and loaded with lspconfig
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "hs" },
              },
            },
          },
        },
        pyright = {
          filetypes = { "python" },
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "off",
                logLevel = "Error",
              },
            },
          },
          single_file_support = true,
        },
        emmet_ls = {
          filetypes = {
            "htmldjango",
            "html",
            "css",
            "scss",
            "typescriptreact",
            "javascriptreact",
            "markdown",
          },
          init_options = {
            html = {
              options = {
                ["bem.enabled"] = true,
              },
            },
          },
        },
        tsserver = {
          settings = {
            completion = {
              completeFunctionCalls = true,
              completePropertyWithSemicolon = true,
              completeJSDocs = true,
              autoImportSuggestions = true,
              importModuleSpecifier = "relative",
              importModuleSpecifierEnding = "minimal",
              importStatementCompletion = "auto",
              nameSuggestions = true,
              paths = {
                { kind = "pathCompletion", trigger = "./", value = "./" },
                { kind = "pathCompletion", trigger = "../", value = "../" },
                { kind = "pathCompletion", trigger = "/", value = "/" },
              },
            },
            documentFormatting = true,
            documentRangeFormatting = true,
          },
        },
        jsonls = {
          filetypes = { "json", "jsonc" },
          setup = {
            commands = {
              Format = {
                function()
                  vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
                end,
              },
            },
          },
          init_options = {
            provideFormatter = true,
          },
          single_file_support = true,
        },
        texlab = {
          filetypes = { "tex", "bib" },
          settings = {
            texlab = {
              auxDirectory = ".",
              bibtexFormatter = "texlab",
              build = {
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                executable = "latexmk",
                forwardSearchAfter = false,
                onSave = false,
              },
              chktex = {
                onEdit = false,
                onOpenAndSave = false,
              },
              diagnosticsDelay = 300,
              formatterLineLength = 80,
              forwardSearch = {
                args = {},
              },
              latexFormatter = "latexindent",
              latexindent = {
                modifyLineBreaks = false,
              },
            },
          },
        },
      },
    },
  },
  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- nls.builtins.formatting.fish_indent,
          -- nls.builtins.diagnostics.fish,
          nls.builtins.diagnostics.flake8,
          nls.builtins.diagnostics.pylint.with({
            command = "pylint",
            -- extra_args = { "--load-plugins", "pylint_django" },
            -- init_options = {
            --     "init-hook='import sys; import os; from pylint.config import find_pylintrc; sys.path.append(os.path.dirname(find_pylintrc()))'",
            -- },
          }),
          nls.builtins.diagnostics.pydocstyle.with({
            extra_args = { "--config=$ROOT/setup.cfg" },
          }),
          nls.builtins.diagnostics.mypy.with({
            extra_args = { "--config-file", "pyproject.toml" },
            -- extra_args = { "--config-file", "mypy.ini" },
            -- extra_args = { "--config-file", "setup.cfg" },
            -- cwd = function(_) return vim.fn.getcwd() end,
            -- runtime_condition = function(params) return utils.path.exists(params.bufname) end,
          }),
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.black,
          nls.builtins.formatting.prettier.with({
            filetypes = {
              "html",
              "css",
              "scss",
              "less",
              "javascript",
              "typescript",
              "vue",
              "json",
              "jsonc",
              "yaml",
              "markdown",
              "handlebars",
            },
            extra_filetypes = {},
          }),
        },
      }
    end,
    config = function()
      local null_ls = require("null-ls")
      local helpers = require("null-ls.helpers")

      local markdownlint = {
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "markdown" },
        -- null_ls.generator creates an async source
        -- that spawns the command with the given arguments and options
        generator = null_ls.generator({
          command = "markdownlint",
          args = { "--stdin" },
          to_stdin = true,
          from_stderr = true,
          -- choose an output format (raw, json, or line)
          format = "line",
          check_exit_code = function(code, stderr)
            local success = code <= 1

            if not success then
              -- can be noisy for things that run often (e.g. diagnostics), but can
              -- be useful for things that run on demand (e.g. formatting)
              print(stderr)
            end

            return success
          end,
          -- use helpers to parse the output from string matchers,
          -- or parse it manually with a function
          on_output = helpers.diagnostics.from_patterns({
            {
              pattern = [[:(%d+):(%d+) [%w-/]+ (.*)]],
              groups = { "row", "col", "message" },
            },
            {
              pattern = [[:(%d+) [%w-/]+ (.*)]],
              groups = { "row", "message" },
            },
          }),
        }),
      }

      null_ls.register(markdownlint)
    end,
  },
  -- mason-null-ls
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = {},
    config = function()
      require("mason-null-ls").setup({
        automatic_setup = false,
        automatic_installation = true,
        ensure_installed = {
          "stylua",
          "prettier",
          "pylint",
          "pydocstyle",
          -- "autopep8",
          "black",
          "flake8",
          "isort",
          "djhtml",
          "djlint",
          "markdownlint",
          "zsh",
          "shellcheck",
          "jq",
        },
      })
    end,
  },
  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      -- add your options that should be passed to the setup() function here
      position = "right",
    },
  },
}
