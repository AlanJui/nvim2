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
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.flake8,
        },
      }
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
