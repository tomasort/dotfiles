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
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        map_cr = true,
        enable_check_bracket_line = false,
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})
    end,
  },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = {
      mappings = {
        around_next = "aa",
        inside_next = "ii",
      },
      n_lines = 500,
    },
  },
  {
    "milanglacier/yarepl.nvim",
    config = function()
      require("yarepl").setup({})
    end,
  },
}
