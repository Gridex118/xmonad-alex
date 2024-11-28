-- Setup language servers.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
--[[
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
--]]

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts) vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {virtual_text = false,}
)

lspconfig.pyright.setup {
    capabilities = capabilities
}

require'lspconfig'.rust_analyzer.setup{
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = false;
            }
        }
    }
}

lspconfig.clojure_lsp.setup {
    capabilities = capabilities
}

lspconfig.texlab.setup {
    capabilities = capabilities,
    handlers = {
        ["textDocument/publishDiagnostics"] = function() end
    }
}

lspconfig.lemminx.setup {
    capabilities = capabilities
}

lspconfig.lua_ls.setup {
    capabilities = capabilities
}

lspconfig.vimls.setup {
    capabilities = capabilities
}

lspconfig.html.setup {
    capabilities = capabilities
}

lspconfig.cssls.setup {
    capabilities = capabilities
}

lspconfig.hls.setup {
    capabilities = capabilities
}

lspconfig.cmake.setup {
    capabilities = capabilities
}

--[[
lspconfig.ccls.setup {
    capabilities = capabilities,
    filetypes = { "c",  },
    init_options = {
        compilationDatabaseDirectory = "build";
        index = {
            threads = 0;
        };
        clang = {
            excludeArgs = { "-frounding-math"} ;
        };
    }
}
--]]

lspconfig.clangd.setup {
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--header-insertion=never";
    },
}

lspconfig.bashls.setup {}
