local M = {}

function M.setup_conform()
  if M._conform_setup then
    return
  end
  M._conform_setup = true

  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      go = { "goimports", "gofumpt" },
      tex = { "latexindent", lsp_format = "fallback" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      jsonc = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      ["_"] = { "trim_whitespace" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      if vim.b[bufnr].autoformat_enabled == false then
        return nil
      end
      return {
        timeout_ms = 500,
        lsp_format = "fallback",
      }
    end,
    notify_on_error = true,
    notify_no_formatters = false,
  })

  vim.api.nvim_create_user_command("Format", function(args)
    require("conform").format({
      async = args.bang,
      lsp_format = "fallback",
    })
  end, { bang = true, desc = "Format current buffer" })

  vim.api.nvim_create_user_command("FormatToggle", function()
    local enabled = vim.b.autoformat_enabled ~= false
    vim.b.autoformat_enabled = not enabled
    print(vim.b.autoformat_enabled and "Autoformat enabled" or "Autoformat disabled")
  end, { desc = "Toggle format on save for current buffer" })
end

function M.setup_lint()
  if M._lint_setup then
    return
  end
  M._lint_setup = true

  local lint = require("lint")

  lint.linters_by_ft = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    lua = { "luacheck" },
    python = { "ruff" },
    go = { "golangcilint" },
    sh = { "shellcheck" },
    bash = { "shellcheck" },
    tex = { "chktex" },
    ["yaml.ansible"] = { "ansible_lint" },
  }

  local group = vim.api.nvim_create_augroup("user_nvim_lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = group,
    callback = function()
      lint.try_lint()
    end,
  })
end

return M