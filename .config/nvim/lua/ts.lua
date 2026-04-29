-- TREESITTER
-- ------------------------------------
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
    "sql",
    "xml",
    "yaml",
    "lua",
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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
