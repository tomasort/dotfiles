return {
  { "nvim-tree/nvim-web-devicons" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer local keymaps",
      },
    },
    opts = {
      preset = "helix",
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        { "<leader>p", group = "project" },
        { "<leader>t", group = "telescope" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },
  {
    "ayu-theme/ayu-vim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("ayu")
      vim.g.ayucolor = "dark"
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#4d5c6d", bg = "NONE" })
      vim.api.nvim_set_hl(0, "NonText", { fg = "#2b3446", bg = "NONE" })
      vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#4d5c6d", bg = "NONE" })
      vim.api.nvim_set_hl(0, "Directory", { fg = "#707c8a", bg = "NONE" })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup({
        indent = {
          char = "▏",
        },
        scope = {
          enabled = false,
          show_end = false,
          highlight = highlight,
          include = {
            node_type = {
              python = { "class_definition", "function_definition", "for_statement", "while_statement", "if_statement", "try_statement", "with_statement" },
              javascript = { "class_definition", "function_definition", "for_statement", "while_statement", "if_statement", "try_statement", "return_statement" },
              typescript = { "class_definition", "function_definition", "for_statement", "while_statement", "if_statement", "try_statement", "return_statement" },
              html = { "tag" },
              yaml = { "block" },
              lua = { "function_definition", "for_statement", "while_statement", "if_statement", "try_statement", "return_statement", "table_constructor" },
            },
          },
        },
      })

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "ayu_mirage",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    "nvzone/minty",
    config = function()
      require("minty").setup({})
    end,
  },
  { "nvzone/typr" },
  { "nvzone/volt" },
}