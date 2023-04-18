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
    -- dependencies = { "mason.nvim" },
    config = function()
      local nls = require("null-ls")
      local lsp_format_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      local nls_on_attach = function(current_client, bufnr)
        -- to setup format on save
        if current_client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = lsp_format_augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = lsp_format_augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                filter = function(client) -- luacheck: ignore
                  --  only use null-ls for formatting instead of lsp server
                  return client.name == "null-ls"
                end,
                bufnr = bufnr,
              })
            end,
          })
        end
      end

      nls.setup({
        on_attach = nls_on_attach,
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
      })
    end,
  },
}
-- mason-null-ls
-- {
--   "jay-babu/mason-null-ls.nvim",
--   event = { "BufReadPre", "BufNewFile" },
--   dependencies = {
--     "williamboman/mason.nvim",
--     "jose-elias-alvarez/null-ls.nvim",
--   },
--   opts = {},
--   config = function()
--     require('mason').setup()
--     require("mason-null-ls").setup({
--       automatic_setup = false,
--       automatic_installation = true,
--       ensure_installed = {
--         "stylua",
--         "prettier",
--         "pylint",
--         "pydocstyle",
--         -- "autopep8",
--         "black",
--         "flake8",
--         "isort",
--         "djhtml",
--         "djlint",
--         "markdownlint",
--         "zsh",
--         "shellcheck",
--         "jq",
--       },
--     })
--   end,
-- }
