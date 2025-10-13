---@type LazyPluginSpec
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,

    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "rust",
            "go",
            "lua",
            "python",
            "markdown",
            "markdown_inline",
        },
        highlight = {
            enable = true,
        },
    },
}
