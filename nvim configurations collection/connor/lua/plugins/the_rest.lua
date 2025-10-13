---@type LazyPluginSpec[]
return {
    { "jiangmiao/auto-pairs" },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({})
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        version = "*", -- Grab the latest working version
        opts = {
            signs_staged_enable = true,
        },
        cond = function()
            return #vim.fs.find(".git", { upward = true }) > 0
        end,
        event = "VeryLazy",
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        ---@type ToggleTermConfig
        opts = {
            open_mapping = [[<c-`>]],
            insert_mappings = true,
        },
    },

    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    }
}
