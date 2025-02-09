-- MASON
-- -----------------------------------
require('mason').setup({})

-- MASON TOOLS
-- -----------------------------------
require('mason-tool-installer').setup {
    -- a list of all tools you want to ensure are installed upon start
    ensure_installed = {
        -- LINTERS
        'ansible-lint',
        'misspell',
        'eslint_d',
    },
}
-- FIDGET
-- -----------------------------------
-- require("fidget").setup({})

-- CMP LSP CONFIGURATION
-- -----------------------------------
local cmp = require('cmp')
local cmp_lsp = require("cmp_nvim_lsp")

local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)

-- MASON LSP CONFIGURATION
-- -----------------------------------
require("mason-lspconfig").setup({
    ensure_installed = {
        "rust_analyzer",
        "lua_ls",
        'ts_ls',
        'rust_analyzer',
        'dockerls',
        'docker_compose_language_service',
        'arduino_language_server',
        'ansiblels',
        'bashls',
        'cmake',
        'cssls',
        'gopls',
        'html',
        'java_language_server',
        'jsonls',
        'marksman',
        'texlab',
    },
    handlers = {
        function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {
                capabilities = capabilities
            }
        end,
        ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = {
                                vim.env.VIMRUNTIME,
                            }
                        }
                    }
                }
            }
        end,
    }
})


require('luasnip.loaders.from_vscode').lazy_load()

-- CMP CONFIGURATION
-- -----------------------------------
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 30
local MIN_LABEL_WIDTH = 30

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<C-Space>'] = cmp.mapping.complete(),            -- TODO: fix is so that we can press enter when nothing is selected and not select the first option by default
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    }),
    formatting = {
        format = function(entry, vim_item)
            local label = vim_item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
            if truncated_label ~= label then
                vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
            elseif string.len(label) < MIN_LABEL_WIDTH then
                local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
                vim_item.abbr = label .. padding
            end
            return vim_item
        end,
    },
})

vim.diagnostic.config({
    -- update_in_insert = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})


-- Apparently needed for nvim-autopairs to work with cmp
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', function(args)
    -- Check if the current line matches a python import regex
    local line = vim.api.nvim_get_current_line()
    local is_import = line:match '^%s*import%s+.*$' or line:match '^%s*from%s+.*$'
    if is_import then
        return
    end
    cmp_autopairs.on_confirm_done()(args)
end
)

-- A flag to keep track of whether autoformat is enabled for the current buffer
local autoformat_enabled = true

-- Function to toggle autoformat for the current buffer
local function toggle_autoformat()
    autoformat_enabled = not autoformat_enabled
    if autoformat_enabled then
        print("Autoformat enabled")
    else
        print("Autoformat disabled")
    end
end

-- LSP CONFIGURATION
-- -----------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
    callback = function(event)
        local opts = { buffer = event.buf }
        -- Key mappings for LSP functions
        vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set('n', '<leader>gd', function()
            vim.cmd('vsplit')
            vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set('n', '<leader>rr', function() vim.lsp.buf.references() end, opts)
        vim.keymap.set('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
        -- Key mapping to toggle autoformat for the current buffer
        vim.keymap.set('n', '<leader>af', toggle_autoformat, opts)
        -- Autoformat on save if the LSP supports formatting
        if event.data and event.data.client_id then
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = event.buf,
                    callback = function()
                        if autoformat_enabled then
                            vim.lsp.buf.format { async = false, bufnr = event.buf }
                        end
                    end,
                })
            end
        end
    end,
})

require 'lspconfig'.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = { 'E501', 'E741' },
                    maxLineLength = 100
                }
            }
        }
    }
}
