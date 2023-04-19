-- Audo keymapping
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require("which-key")
      local Util = require("lazyvim.util")

      wk.setup(opts)
      local keymaps = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>d"] = { name = "+debug" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+utilities" },
        ["<leader>uu"] = { name = "+ui" },
        ["<leader>w"] = {
          name = "+windows",
          { "<leader>wm", "<CMD>MaximizerToggle<CR>", desc = "Max/Org Window" },
          { "<leader>wc", "<CMD>close<CR>", desc = "Close Window" },
          { "<leader>wi", "<CMD>tabnew %<CR>", desc = "Zoom-in Window" },
          { "<leader>wo", "<CMD>tabclose<CR>", desc = "Zoom-out Window" },
          { "<leader>wh", "<CMD>split<CR>", desc = "H-Split" },
          { "<leader>wv", "<CMD>vsplit<CR>", desc = "V-Split" },
          { "<leader>w=", "<C-w>=", desc = "Equal Width" },
        },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
        ["<leader>z"] = { name = "+system" },
      }
      if Util.has("noice.nvim") then
        keymaps["<leader>sn"] = { name = "+noice" }
      end
      wk.register(keymaps)
    end,
  },
}
