local map = vim.keymap.set

return {
  { "tpope/vim-commentary" },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "rafamadriz/friendly-snippets" },
  {
    "mattn/emmet-vim",
    init = function()
      vim.g.user_emmet_leader_key = "<C-y>"
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        map_cr = true,
        enable_check_bracket_line = false,
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})

      map("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })

      map("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })
    end,
  },
  {
    "milanglacier/yarepl.nvim",
    config = function()
      require("yarepl").setup({})
    end,
  },
}