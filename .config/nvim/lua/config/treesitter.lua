local languages = {
  "c",
  "cpp",
  "cmake",
  "css",
  "diff",
  "gitignore",
  "go",
  "html",
  "http",
  "java",
  "javascript",
  "typescript",
  "tsx",
  "json",
  "query",
  "sql",
  "xml",
  "yaml",
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "markdown",
  "markdown_inline",
  "make",
  "dockerfile",
  "bash",
  "nginx",
  "matlab",
  "rust",
  "python",
  "toml",
}

local install_dir = vim.fn.stdpath("data") .. "/treesitter"

require("nvim-treesitter").setup({
  install_dir = install_dir,
})

require("nvim-treesitter").install(languages)

-- Map common markdown fence names to installed parsers for injected highlighting.
local aliases = {
  bash = { "sh", "shell", "console" },
  javascript = { "js" },
  typescript = { "ts" },
  python = { "py" },
  yaml = { "yml" },
}

for parser, filetypes in pairs(aliases) do
  for _, filetype in ipairs(filetypes) do
    vim.treesitter.language.register(parser, filetype)
  end
end

local function treesitter_try_attach(bufnr, filetype)
  local language = vim.treesitter.language.get_lang(filetype) or filetype
  if not pcall(vim.treesitter.start, bufnr, language) then
    return
  end

  if vim.treesitter.query.get(language, "indents") ~= nil then
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    treesitter_try_attach(args.buf, args.match)
  end,
})
