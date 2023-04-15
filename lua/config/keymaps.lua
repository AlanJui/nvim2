-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap.set

keymap("i", "jj", "<Esc>")
keymap("i", "jk", "<Esc>")

--------------------------------------------------------------------
-- Windows navigation
--------------------------------------------------------------------
-- Split window
keymap("n", "<localleader>sh", ":split<CR>")
keymap("n", "<localleader>sv", ":vsplit<CR>")
keymap("n", "<localleader>se", "<C-w>=") -- make split windows equal width & height
keymap("n", "<localleader>sx", ":close<CR>") -- close current split window

-- Move focus on window
keymap("n", "<ESC>k", "<cmd>wincmd k<CR>")
keymap("n", "<ESC>j", "<cmd>wincmd j<CR>")
keymap("n", "<ESC>h", "<cmd>wincmd h<CR>")
keymap("n", "<ESC>l", "<cmd>wincmd l<CR>")

-- keymap("n", "<C-k>", "<cmd>wincmd k<CR>")
-- keymap("n", "<C-j>", "<cmd>wincmd j<CR>")
-- keymap("n", "<C-h>", "<cmd>wincmd h<CR>")
-- keymap("n", "<C-l>", "<cmd>wincmd l<CR>")

-- keymap("n", "<S-Up>", "<cmd>wincmd k<CR>")
-- keymap("n", "<S-Down>", "<cmd>wincmd j<CR>")
-- keymap("n", "<S-Left>", "<cmd>wincmd h<CR>")
-- keymap("n", "<S-Right>", "<cmd>wincmd l<CR>")

-- Window Resize
keymap("n", "<M-Up>", "<cmd>wincmd -<CR>")
keymap("n", "<M-Down>", "<cmd>wincmd +<CR>")
keymap("n", "<M-Left>", "<cmd>wincmd <<CR>")
keymap("n", "<M-Right>", "<cmd>wincmd ><CR>")

-- Window Zoom In/Out
keymap("n", "<C-w>i", ":tabnew %<CR>")
keymap("n", "<C-w>o", ":tabclose<CR>")

-- maximizer window
keymap("n", "<localleader>sm", ":MaximizerToggle<CR>") -- close current split window

--------------------------------------------------------------------
-- Buffers
--------------------------------------------------------------------

-- Tab navigation
keymap("n", "<localleader>to", ":tabnew<CR>") -- open new tab
keymap("n", "<localleader>tx", ":tabclose<CR>") -- close current tab
keymap("n", "<localleader>tn", ":tabn<CR>") --  go to next tab
keymap("n", "<localleader>tp", ":tabp<CR>") --  go to previous tab

-- Tab operations
keymap("n", "gt", "<cmd>bn<CR>")
keymap("n", "gT", "<cmd>bp<CR>")

--------------------------------------------------------------------
-- Terminal mode
--------------------------------------------------------------------
keymap("t", "<Esc>", "<C-\\><C-n>")
