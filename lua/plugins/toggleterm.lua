return {
  "vifm/vifm.vim",
  "akinsho/toggleterm.nvim",
  dependencies = {},
  keys = {
    { [[<C-\>]] },
    {
      "<leader>0",
      "<cmd>2ToggleTerm<cr>",
      desc = "Terminal #2",
    },
    {
      "<leader>gg",
      "<cmd>lua _lazygit_toggle()<cr>",
      desc = "LazyGit",
    },
    {
      "<leader>fV",
      ":Vifm<cr>",
      desc = "ViFm",
    },
    {
      "<leader>Uv",
      ":2TermExec cmd='vifm'<cr>",
      desc = "ViFm",
    },
    {
      "<leader>Ug",
      ":2TermExec cmd='git status'<cr>",
      desc = "git status",
    },
  },
  cmd = { "ToggleTerm", "TermExec", "2TermExec" },
  opts = {
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
    shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
    shading_factor = "0.3", -- the percentage by which to lighten terminal background, default: -30 (gets multiplied by -3 if background is light)
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    direction = "float",
    shell = vim.o.shell,
    auto_scroll = true, -- automatically scroll to the bottom on terminal output
  },
  config = function()
    vim.cmd([[
      autocmd termenter term://*toggleterm#*
            \ tnoremap <silent><c-t> <cmd>exe v:count1 . "toggleterm"<cr>

      nnoremap <silent><c-t> <cmd>exe v:count1 . "toggleterm"<cr>
      inoremap <silent><c-t> <esc><cmd>exe v:count1 . "toggleterm"<cr>
    ]])

    local Terminal = require("toggleterm.terminal").Terminal

    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "double",
      },
      -- function to run on opening the terminal
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
      end,
      -- function to run on closing the terminal
      on_close = function(term)
        vim.cmd("startinsert!")
      end,
    })

    function _lazygit_toggle()
      lazygit:toggle()
    end
  end,
}
