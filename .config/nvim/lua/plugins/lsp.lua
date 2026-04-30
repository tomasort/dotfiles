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
      require("config.lsp")
    end,
  },
  { "neovim/nvim-lspconfig" },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "VimEnter",
    dependencies = {
      "saghen/blink.lib",
      "L3MON4D3/LuaSnip",
    },
    build = ":BlinkCmp build",
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "select_and_accept", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = {
          auto_show = true,
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },
        documentation = {
          auto_show = false,
          auto_show_delay_ms = 500,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = {
        preset = "luasnip",
      },
      signature = {
        enabled = true,
      },
    },
  },
  { "j-hui/fidget.nvim", opts = {} },
  {
    "stevearc/conform.nvim",
    config = function()
      require("config.tooling").setup_conform()
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("config.tooling").setup_lint()
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    opts = {},
  },
}