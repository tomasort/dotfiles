local map = vim.keymap.set
local silent = { silent = true }

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "zbirenbaum/copilot.lua",
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
            normal = "<leader-l>",
            insert = "<leader-l>",
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

      map("i", "<Tab>", function()
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