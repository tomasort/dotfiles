return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("config.treesitter")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            local move = require("nvim-treesitter-textobjects.move")

            require("nvim-treesitter-textobjects").setup({
                move = {
                    set_jumps = true,
                },
            })

            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                move.goto_next_start("@function.outer", "textobjects")
            end, { desc = "Next function start" })
            vim.keymap.set({ "n", "x", "o" }, "[[", function()
                move.goto_previous_start("@class.outer", "textobjects")
            end, { desc = "Previous class start" })
            vim.keymap.set({ "n", "x", "o" }, "]]", function()
                move.goto_next_start("@class.outer", "textobjects")
            end, { desc = "Next class start" })
            vim.keymap.set({ "n", "x", "o" }, "[m", function()
                move.goto_previous_start("@function.outer", "textobjects")
            end, { desc = "Previous function start" })
            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                move.goto_next_end("@function.outer", "textobjects")
            end, { desc = "Next function end" })
            vim.keymap.set({ "n", "x", "o" }, "[M", function()
                move.goto_previous_end("@function.outer", "textobjects")
            end, { desc = "Previous function end" })
            vim.keymap.set({ "n", "x", "o" }, "][", function()
                move.goto_next_end("@class.outer", "textobjects")
            end, { desc = "Next class end" })
            vim.keymap.set({ "n", "x", "o" }, "[]", function()
                move.goto_previous_end("@class.outer", "textobjects")
            end, { desc = "Previous class end" })
        end,
    },
    { "HiPhish/rainbow-delimiters.nvim" },
    -- {
    --     "windwp/nvim-ts-autotag",
    --     dependencies = { "nvim-treesitter/nvim-treesitter" },
    --     config = function()
    --         require("nvim-ts-autotag").setup({
    --             opts = {
    --                 enable_close = true,
    --                 enable_rename = true,
    --                 enable_close_on_slash = false,
    --             },
    --             per_filetype = {
    --                 html = {
    --                     enable_close = true,
    --                 },
    --             },
    --         })
    --     end,
    -- },
}
