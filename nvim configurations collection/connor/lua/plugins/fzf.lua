---@type LazyPluginSpec
return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        global = {
            pickers = function()
                local utils = require("fzf-lua.utils")
                local clients = utils.lsp_get_clients({ bufnr = utils.CTX().bufnr })
                local doc_sym_supported = vim.iter(clients):any(function(client)
                    return client:supports_method("textDocument/documentSymbol")
                end)
                local wks_sym_supported = vim.iter(clients):any(function(client)
                    return client:supports_method("workspace/symbol")
                end)
                local ret = {
                    { "files", desc = "Files" },
                    { "buffers", desc = "Bufs", prefix = "$" },
                }
                if doc_sym_supported then
                    ret[#ret + 1] = {
                        "lsp_document_symbols",
                        desc = "Sym(buf)",
                        prefix = "@",
                        opts = { no_autoclose = true },
                    }
                end

                if wks_sym_supported then
                    ret[#ret + 1] = {
                        "lsp_workspace_symbols",
                        desc = "Sym(project)",
                        prefix = "#",
                        opts = { no_autoclose = true },
                    }
                end
                return ret
            end,
        },
    },
}
