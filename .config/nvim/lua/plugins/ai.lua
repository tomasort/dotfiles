local silent = { silent = true }

return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    keys = {
      {
        "<leader>oa",
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Ask OpenCode about selection",
      },
      {
        "<leader>os",
        function()
          require("opencode").select()
        end,
        desc = "Open OpenCode action picker",
      },
      {
        "<leader>ot",
        function()
          require("opencode").toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle OpenCode",
      },
    },
    config = function()
      vim.g.opencode_opts = {}
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "zbirenbaum/copilot.lua",
    },
    keys = {
      { "<leader>cc", "<Cmd>CopilotChat<CR>", desc = "Open Copilot Chat" },
    },
    config = function()
      require("CopilotChat").setup({
        mappings = {
          complete = {
            insert = "<Tab>",
          },
          close = {
            normal = "q",
            insert = "<C-c>",
          },
          reset = {
            normal = "<leader>l",
            insert = "<leader>l",
          },
        },
        model = "gpt-4.1",
      })

      require("copilot").setup({
        panel = {
          auto_trigger = true,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = false,
          },
        },
      })

      vim.keymap.set("i", "<Tab>", function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
        end
      end, vim.tbl_extend("force", silent, { desc = "Accept Copilot suggestion" }))
    end,
  },
  { "zbirenbaum/copilot.lua" },
}
