local map = vim.keymap.set

return {
  { "nvim-lua/plenary.nvim" },
  { "mbbill/undotree" },
  { "tpope/vim-fugitive" },
  { "kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "junegunn/fzf", build = "./install --all" },
  { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.telescope")
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
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
      })
    end,
  },
  { "christoomey/vim-tmux-navigator" },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      local harpoon = require("harpoon")
      local conf = require("telescope.config").values

      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        local make_finder = function()
          local paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(paths, item.value)
          end

          return require("telescope.finders").new_table({ results = paths })
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
          layout_config = {
            height = 0.4,
            width = 0.7,
          },
          attach_mappings = function(prompt_bufnr, map_telescope)
            map_telescope("i", "<C-d>", function()
              local state = require("telescope.actions.state")
              local selected_entry = state.get_selected_entry()
              local current_picker = state.get_current_picker(prompt_bufnr)

              table.remove(harpoon_files.items, selected_entry.index)
              current_picker:refresh(make_finder())
            end)
            return true
          end,
        }):find()
      end

      harpoon:setup()

      map("n", "<leader>a", function()
        harpoon:list():add()
      end)
      map("n", "<leader>1", function()
        harpoon:list():select(1)
      end)
      map("n", "<leader>2", function()
        harpoon:list():select(2)
      end)
      map("n", "<leader>3", function()
        harpoon:list():select(3)
      end)
      map("n", "<leader>4", function()
        harpoon:list():select(4)
      end)
      map("n", "<leader>5", function()
        harpoon:list():select(5)
      end)
      map("n", "<C-S-P>", function()
        harpoon:list():prev()
      end)
      map("n", "<C-S-N>", function()
        harpoon:list():next()
      end)
      map("n", "<C-e>", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon window" })

      harpoon:extend({
        UI_CREATE = function(cx)
          map("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })

          map("n", "<C-h>", function()
            harpoon.ui:select_menu_item({ split = true })
          end, { buffer = cx.bufnr })
        end,
      })
    end,
  },
}