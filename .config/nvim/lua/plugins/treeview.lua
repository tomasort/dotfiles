return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
        keys = {
            { "<leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
            { "<leader>ef", "<Cmd>NvimTreeFindFile<CR>", desc = "Find current file in NvimTree" },
        },
        opts = {
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 30,
                relativenumber = true
            },
            renderer = {
                group_empty = true,
            },
        },
    },
}
