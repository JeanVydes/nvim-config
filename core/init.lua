require("config.lazy")

local vim = vim
local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local indent = 4

opt.termguicolors = true
vim.g.mapleader = '\\'

-- EDITOR
opt.list = true
opt.number = true
opt.mouse = 'a'
opt.showcmd = true
opt.autochdir = true
opt.clipboard = 'unnamedplus'
-- opt.silent = true
opt.syntax = 'enable'

-- Indent
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.softtabstop = indent
opt.tabstop = indent

-- Search
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wildignore = opt.wildignore + { '*/node_modules/*', '*/.git/*', '*/vendor/*' }
opt.wildmenu = true

-- Performance
opt.redrawtime = 1500
opt.timeoutlen = 200
opt.ttimeoutlen = 10
opt.updatetime = 100

-- Auto Complete
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.shortmess = opt.shortmess + { c = true }

-- MAPPING
local map = vim.api.nvim_set_keymap

map('n', '<leader>n', ':Neotree toggle<CR>', { desc = "Toggle NeoTree" })
-- Focus on NeoTree
map('n', '<C-A-ñ>', ':NeoTreeFocus<CR>', { desc = "Focus on NeoTree" })
-- undo
map('n', '<leader>z', ':undo<CR>', { desc = "Undo" })
-- write
map('n', '<leader>w', ':w<CR>', { desc = "Write" })
-- quit
map('n', '<leader>q', ':q<CR>', { desc = "Quit" })
-- quit all
map('n', '<leader>qa', ':qa<CR>', { desc = "Quit All" })
-- open termina
map('n', '<leader>t', ':terminal<CR>', { desc = "Open Terminal" })
-- open terminal in horizontal split
map('n', '<leader>th', ':sp<CR>:terminal<CR>', { desc = "Open Terminal Horizontal" })
-- open terminal in vertical split
map('n', '<leader>tv', ':vsp<CR>:terminal<CR>', { desc = "Open Terminal Vertical" })
-- switch tabtab
map('n', '<leader><TAB>', ':BufferNext<CR>', { desc = "Switch Tab" })
