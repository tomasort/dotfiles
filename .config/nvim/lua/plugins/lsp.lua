return {
  { "williamboman/mason.nvim" },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("lsp")
    end,
  },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp", dependencies = { "hrsh7th/nvim-cmp" } },
  { "hrsh7th/cmp-buffer", dependencies = { "hrsh7th/nvim-cmp" } },
  { "hrsh7th/cmp-path", dependencies = { "hrsh7th/nvim-cmp" } },
  { "hrsh7th/cmp-cmdline", dependencies = { "hrsh7th/nvim-cmp" } },
  { "hrsh7th/nvim-cmp" },
  { "L3MON4D3/LuaSnip" },
  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = { "hrsh7th/nvim-cmp", "L3MON4D3/LuaSnip" },
  },
  { "j-hui/fidget.nvim" },
}