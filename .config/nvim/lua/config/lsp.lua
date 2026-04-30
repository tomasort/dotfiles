require("mason").setup({})

require("mason-tool-installer").setup({
  ensure_installed = {
    "ansible-lint",
    "black",
    "luacheck",
    "misspell",
    "eslint_d",
    "gofumpt",
    "goimports",
    "golangci-lint",
    "isort",
    "prettierd",
    "ruff",
    "shellcheck",
    "shfmt",
    "stylua",
  },
})

local blink = require("blink.cmp")
local capabilities = blink.get_lsp_capabilities()

require("mason-lspconfig").setup({
  ensure_installed = {
    "rust_analyzer",
    "lua_ls",
    "ts_ls",
    "dockerls",
    "docker_compose_language_service",
    "arduino_language_server",
    "ansiblels",
    "bashls",
    "cmake",
    "cssls",
    "gopls",
    "html",
    "jdtls",
    "marksman",
    "texlab",
    "pylsp",
  },
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = capabilities,
      })
    end,
    ["lua_ls"] = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          },
        },
      })
    end,
  },
})

require("luasnip.loaders.from_vscode").lazy_load()

local document_highlight_group = vim.api.nvim_create_augroup("user_lsp_document_highlight", { clear = true })

vim.diagnostic.config({
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

vim.lsp.config("pylsp", {
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        pycodestyle = {
          ignore = { "E501", "E741", "E402" },
          maxLineLength = 100,
        },
      },
    },
  },
})

local lsp_keymaps = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_keymaps,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition()
    end, { buffer = event.buf, desc = "Go to definition" })
    vim.keymap.set("n", "<leader>gd", function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
    end, { buffer = event.buf, desc = "Definition in split" })
    vim.keymap.set("n", "gi", function()
      vim.lsp.buf.implementation()
    end, { buffer = event.buf, desc = "Go to implementation" })
    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { buffer = event.buf, desc = "References" })
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, { buffer = event.buf, desc = "Hover documentation" })
    vim.keymap.set("n", "<leader>vws", function()
      vim.lsp.buf.workspace_symbol()
    end, { buffer = event.buf, desc = "Workspace symbols" })
    vim.keymap.set("n", "<leader>vd", function()
      vim.diagnostic.open_float()
    end, { buffer = event.buf, desc = "Line diagnostics" })
    vim.keymap.set("n", "<leader>ca", function()
      vim.lsp.buf.code_action()
    end, { buffer = event.buf, desc = "Code action" })
    vim.keymap.set("n", "<leader>rr", function()
      vim.lsp.buf.references()
    end, { buffer = event.buf, desc = "Symbol references" })
    vim.keymap.set("n", "<leader>rn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { buffer = event.buf, desc = "Rename symbol", expr = true })
    if client and client:supports_method("textDocument/inlayHint") then
      vim.keymap.set("n", "<leader>ci", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
      end, { buffer = event.buf, desc = "Toggle inlay hints" })
    end
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.goto_prev()
    end, { buffer = event.buf, desc = "Previous diagnostic" })
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.goto_next()
    end, { buffer = event.buf, desc = "Next diagnostic" })
    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, { buffer = event.buf, desc = "Signature help" })

    if client and client:supports_method("textDocument/documentHighlight") then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = document_highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = document_highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        buffer = event.buf,
        group = document_highlight_group,
        callback = function(detach_event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = document_highlight_group, buffer = detach_event.buf })
        end,
      })
    end
  end,
})
