return {{"xiyaowong/transparent.nvim"}, {
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd [[colorscheme tokyodark]]
    end
}, {
    "mskelton/termicons.nvim",
    requires = {"nvim-tree/nvim-web-devicons"},
    build = false,
    config = function(_, opts)
        require("termicons").setup()
    end
}, {"nvim-tree/nvim-web-devicons"}}
