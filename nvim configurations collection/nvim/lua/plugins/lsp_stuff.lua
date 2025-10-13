local _capab = nil
local function capab()
    if _capab ~= nil then
        _capab = require("cmp_nvim_lsp").default_capabilities()
    end
    return _capab
end
return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {

            ensure_installed = {
                "ruff",
                "basedpyright",
                "lua_ls",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capab(),
                    })
                end,
            },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
    },
    {
        "https://github.com/hrsh7th/cmp-nvim-lsp",
        opts = {},
        dependencies = {
            {
                "hrsh7th/nvim-cmp",
                opts = {},
            },
        },
    },
}
