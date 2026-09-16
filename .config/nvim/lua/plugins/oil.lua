return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        keys = {
            { "-", "<cmd>Oil<CR>", desc = "Open Parent Directory in Oil" },
            { "<leader>-v", "<Cmd>bel vsplit<CR><Cmd>Oil<CR>", desc = "Open Oil in vertical split" },
            { "<leader>-h", "<Cmd>bel split<CR><Cmd>Oil<CR>", desc = "Open Oil in horizontal split" },
        },
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                view_options = {
                    show_hidden = true,
                    is_hidden_file = function(name, _)
                        return vim.startswith(name, ".")
                    end,
                    is_always_hidden = function(_, _)
                        return false
                    end,
                    natural_order = false,
                    sort = {
                        { "type", "asc" },
                        { "name", "asc" },
                    },
                },
                float = {
                    padding = 2,
                    max_width = 0,
                    max_height = 0,
                    border = "single",
                    win_options = {
                        winblend = 0,
                    },
                    get_win_title = nil,
                    preview_split = "auto",
                    override = function(conf)
                        return conf
                    end,
                },
            })
        end,
    }
}