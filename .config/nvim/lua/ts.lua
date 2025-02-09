-- TREESITTER
-- ------------------------------------
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = {
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
        "toml"
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
