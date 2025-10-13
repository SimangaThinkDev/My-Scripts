---@type LazyPluginSpec
return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" }, -- If not loaded, load just as we write a file
    cmd = { "ConformInfo" }, -- If not loaded, load when this command is run
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = {
                "ruff_fix",
                "ruff_format",
                "ruff_organize_imports",
            },
            go = { "gofmt", "goimports" },
            markdown = { "mdformat" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
        format_on_save = {
            timeout_ms = 500,
        },
        init = function()
            -- If you want the formatexpr, here is the place to set it
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
}
