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

local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")

local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp_lsp.default_capabilities()
)

require("mason-lspconfig").setup({
  ensure_installed = {
    "rust_analyzer",
    "lua_ls",
    "ts_ls",
    "rust_analyzer",
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

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local ellipsis_char = "..."
local max_label_width = 30
local min_label_width = 30

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  completion = {
    autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
  },
  window = {},
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "lazydev", group_index = 0 },
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
  formatting = {
    format = function(_, vim_item)
      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, max_label_width)
      if truncated_label ~= label then
        vim_item.abbr = truncated_label .. ellipsis_char
      elseif string.len(label) < min_label_width then
        local padding = string.rep(" ", min_label_width - string.len(label))
        vim_item.abbr = label .. padding
      end
      return vim_item
    end,
  },
})

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

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", function(args)
  local line = vim.api.nvim_get_current_line()
  local is_import = line:match("^%s*import%s+.*$") or line:match("^%s*from%s+.*$")
  if is_import then
    return
  end
  cmp_autopairs.on_confirm_done()(args)
end)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition()
    end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "<leader>gd", function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
    end, vim.tbl_extend("force", opts, { desc = "Definition in split" }))
    vim.keymap.set("n", "gi", function()
      vim.lsp.buf.implementation()
    end, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, vim.tbl_extend("force", opts, { desc = "References" }))
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    vim.keymap.set("n", "<leader>vws", function()
      vim.lsp.buf.workspace_symbol()
    end, vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))
    vim.keymap.set("n", "<leader>vd", function()
      vim.diagnostic.open_float()
    end, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
    vim.keymap.set("n", "<leader>ca", function()
      vim.lsp.buf.code_action()
    end, vim.tbl_extend("force", opts, { desc = "Code action" }))
    vim.keymap.set("n", "<leader>rr", function()
      vim.lsp.buf.references()
    end, vim.tbl_extend("force", opts, { desc = "Symbol references" }))
    vim.keymap.set("n", "<leader>rn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, vim.tbl_extend("force", opts, { desc = "Rename symbol", expr = true }))
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.goto_next()
    end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.goto_prev()
    end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, vim.tbl_extend("force", opts, { desc = "Signature help" }))
  end,
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