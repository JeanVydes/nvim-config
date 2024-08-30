-- require("core.init")
require("config.lazy")

local vim = vim

-- Vim options
local opt = vim.opt
local g = vim.g
local indent = 4

-- Set leader key
vim.g.mapleader = " " -- Changed to space for easier access

-- EDITOR settings
opt.termguicolors = true
opt.list = true
opt.number = true
opt.mouse = 'a'
opt.showcmd = true
opt.autochdir = true
opt.clipboard = 'unnamedplus'
opt.syntax = 'enable'

-- Indent settings
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.softtabstop = indent
opt.tabstop = indent

-- Search settings
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wildignore:append{'*/node_modules/*', '*/.git/*', '*/vendor/*'}
opt.wildmenu = true

-- Performance settings
opt.redrawtime = 1500
opt.timeoutlen = 200
opt.ttimeoutlen = 10
opt.updatetime = 100

-- Auto Complete settings
opt.completeopt = {'menu', 'menuone', 'noselect'}
opt.shortmess:append{
    c = true
}

-- MAPPING
local function map(mode, lhs, rhs, opts)
    local options = {
        noremap = true,
        silent = true
    }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- NeoTree mappings
map('n', '<leader>n', ':Neotree toggle<CR>', {
    desc = "Toggle NeoTree"
})
map('n', '<leader>nf', ':Neotree focus<CR>', {
    desc = "Focus on NeoTree"
})

-- Other mappings
map('n', '<leader>z', ':undo<CR>', {
    desc = "Undo"
})
map('n', '<leader>w', ':w<CR>', {
    desc = "Write"
})
map('n', '<leader>q', ':q<CR>', {
    desc = "Quit"
})
map('n', '<leader>qa', ':qa<CR>', {
    desc = "Quit All"
})
map('n', '<leader>t', ':terminal<CR>', {
    desc = "Open Terminal"
})
map('n', '<leader>th', ':split | terminal<CR>', {
    desc = "Open Terminal Horizontal"
})
map('n', '<leader>tv', ':vsplit | terminal<CR>', {
    desc = "Open Terminal Vertical"
})
map('n', '<leader>}', ':BufferNext<CR>', {
    desc = "Switch Tab"
})
map('n', '<leader>{', ':BufferPrevious<CR>', {
    desc = "Switch Tab"
})

------------------------------------------------------------------------------------------
local lspconfig = require('lspconfig')

-- Check if rust-analyzer is executable
local function is_executable(command)
    local handle = io.popen("command -v " .. command .. " >/dev/null 2>&1 && echo 'true' || echo 'false'")

    if handle == nil then
        return false
    end

    local result = handle:read("*a")

    handle:close()
    return result:gsub("%s+", "") == "true"
end

-- Define the on_attach function
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = {
        noremap = true,
        silent = true,
        buffer = bufnr
    }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

    -- You can add more key mappings here as needed
end

-- Setup rust-analyzer if it's available
if is_executable('rust-analyzer') then
    lspconfig.rust_analyzer.setup({
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module"
                    },
                    prefix = "self"
                },
                cargo = {
                    buildScripts = {
                        enable = true
                    }
                },
                procMacro = {
                    enable = true
                },
                inlayHints = {
                    enable = true,
                    showParameterNames = true,
                    parameterHintsPrefix = "<- ",
                    otherHintsPrefix = "=> "
                }
            }
        }
    })
end

local rt = require("rust-tools")

rt.setup({
    tools = {
        executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
        reload_workspace_from_cargo_toml = true,
        inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = "<-",
            other_hints_prefix = "=>",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment"
        },
        hover_actions = {
            border = {{"╭", "FloatBorder"}, {"─", "FloatBorder"}, {"╮", "FloatBorder"}, {"│", "FloatBorder"},
                      {"╯", "FloatBorder"}, {"─", "FloatBorder"}, {"╰", "FloatBorder"}, {"│", "FloatBorder"}},
            auto_focus = true
        }
    },
    server = {
        on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, {
                buffer = bufnr
            })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, {
                buffer = bufnr
            })
        end
    }
})

-- LSP Diagnostics Options Setup 
local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({
    name = 'DiagnosticSignError',
    text = ''
})
sign({
    name = 'DiagnosticSignWarn',
    text = ''
})
sign({
    name = 'DiagnosticSignHint',
    text = ''
})
sign({
    name = 'DiagnosticSignInfo',
    text = ''
})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = ''
    }
})

vim.cmd([[
  set signcolumn=yes
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
  ]])
