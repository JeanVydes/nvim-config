return {
    'rmagatti/auto-session',
    lazy = false,
    dependencies = {'nvim-telescope/telescope.nvim'
    },
    opts = {
        suppressed_dirs = {'~/', '~/Projects', '~/Downloads', '/'}
    }
}
