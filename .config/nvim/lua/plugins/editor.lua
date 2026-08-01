return {
    { "nvim-lua/plenary.nvim" },
    {
        "nmac427/guess-indent.nvim", 
        opt={} 
    },
    -- { "tpope/vim-fugitive" }	,
    -- { "tpope/vim-sleuth" },
    { 
        "kdheepak/lazygit.nvim", 
        dependencies = { "nvim-lua/plenary.nvim" } 
    },
    { "mbbill/undotree" },
    { "christoomey/vim-tmux-navigator" },
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
            },
            renderer = {
                group_empty = true,
            },
        },
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
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
                    -- Padding around the floating window
                    padding = 2,
                    -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                    max_width = 0,
                    max_height = 0,
                    border = "single",
                    win_options = {
                        winblend = 0,
                    },
                    -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
                    get_win_title = nil,
                    -- preview_split: Split direction: "auto", "left", "right", "above", "below".
                    preview_split = "auto",
                    -- This is the config that will be passed to nvim_open_win.
                    -- Change values here to customize the layout
                    override = function(conf)
                        return conf
                    end,
                },
            })
        end,
    },
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- or if using mini.icons/mini.nvim
        -- dependencies = { "nvim-mini/mini.icons" },
        ---@module "fzf-lua"
        ---@type fzf-lua.Config|{}
        ---@diagnostic disable: missing-fields
        opts = {},
        ---@diagnostic enable: missing-fields
        keys = {
            {
                "<leader>ff", 
                function() 
                    require('fzf-lua').files() 
                end,
                desc="Find Files in Current working directory"
            },
            {
                "<leader>fg", 
                function() 
                    require('fzf-lua').live_grep() 
                end,
                desc="Find by doing live grep in Current working directory"
            },
            {
                "<leader>fc", 
                function() 
                    require('fzf-lua').files({cwd=vim.fn.stdpath("config")}) 
                end,
                desc="Find by doing live grep in Current working directory"
            }
        },
    },

-- 	{
-- 		"sindrets/diffview.nvim",
-- 		dependencies = { "nvim-lua/plenary.nvim" },
-- 		opts = {},
-- 	},
-- 	{
-- 		"lewis6991/gitsigns.nvim",
-- 		event = { "BufReadPre", "BufNewFile" },
-- 		opts = {
-- 			on_attach = function(bufnr)
-- 				local gitsigns = require("gitsigns")
-- 
-- 				vim.keymap.set("n", "]c", function()
-- 					if vim.wo.diff then
-- 						vim.cmd.normal({ "]c", bang = true })
-- 					else
-- 						gitsigns.nav_hunk("next")
-- 					end
-- 				end, { buffer = bufnr, desc = "Next git hunk" })
-- 				vim.keymap.set("n", "[c", function()
-- 					if vim.wo.diff then
-- 						vim.cmd.normal({ "[c", bang = true })
-- 					else
-- 						gitsigns.nav_hunk("prev")
-- 					end
-- 				end, { buffer = bufnr, desc = "Previous git hunk" })
-- 
-- 				vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
-- 				vim.keymap.set("v", "<leader>hs", function()
-- 					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
-- 				end, { buffer = bufnr, desc = "Stage selected hunk" })
-- 				vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
-- 				vim.keymap.set("v", "<leader>hr", function()
-- 					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
-- 				end, { buffer = bufnr, desc = "Reset selected hunk" })
-- 				vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
-- 				vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
-- 				vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
-- 				vim.keymap.set(
-- 					"n",
-- 					"<leader>hi",
-- 					gitsigns.preview_hunk_inline,
-- 					{ buffer = bufnr, desc = "Preview hunk inline" }
-- 				)
-- 				vim.keymap.set("n", "<leader>hb", function()
-- 					gitsigns.blame_line({ full = true })
-- 				end, { buffer = bufnr, desc = "Blame line" })
-- 				vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { buffer = bufnr, desc = "Diff against index" })
-- 				vim.keymap.set("n", "<leader>hD", function()
-- 					gitsigns.diffthis("@")
-- 				end, { buffer = bufnr, desc = "Diff against last commit" })
-- 				vim.keymap.set(
-- 					"n",
-- 					"<leader>hq",
-- 					gitsigns.setqflist,
-- 					{ buffer = bufnr, desc = "Populate quickfix with hunks" }
-- 				)
-- 				vim.keymap.set("n", "<leader>hQ", function()
-- 					gitsigns.setqflist("all")
-- 				end, { buffer = bufnr, desc = "Populate quickfix with repo hunks" })
-- 			end,
-- 		},
-- 	},
	-- { "junegunn/fzf", build = "./install --all" },
-- 	{ "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },
-- 	{
-- 		"nvim-telescope/telescope.nvim",
-- 		dependencies = {
-- 			"nvim-lua/plenary.nvim",
-- 			{ "nvim-telescope/telescope-ui-select.nvim" },
-- 			{
-- 				"nvim-telescope/telescope-fzf-native.nvim",
-- 				build = "make",
-- 				cond = function()
-- 					return vim.fn.executable("make") == 1
-- 				end,
-- 			},
-- 		},
-- 		config = function()
-- 			require("config.telescope")
-- 		end,
-- 	},
-- 	{
-- 		"nvim-telescope/telescope-file-browser.nvim",
-- 		dependencies = {
-- 			"nvim-telescope/telescope.nvim",
-- 			"nvim-lua/plenary.nvim",
-- 		},
-- 	},
-- 	{
-- 		"numToStr/FTerm.nvim",
-- 		opts = {
-- 			border = "single",
-- 			dimensions = {
-- 				height = 0.8,
-- 				width = 0.8,
-- 			},
-- 		},
-- 		config = function(_, opts)
-- 			require("FTerm").setup(opts)
-- 		end,
-- 		keys = {
-- 			{ "<leader>z", "<Cmd>lua require('FTerm').open()<CR>", desc = "Open floating terminal" },
-- 			{
-- 				"<Esc>",
-- 				"<C-\\><C-n><Cmd>lua require('FTerm').close()<CR>",
-- 				mode = "t",
-- 				desc = "Close floating terminal",
-- 			},
-- 		},
-- 	},
-- 	{
-- 		"ThePrimeagen/harpoon",
-- 		branch = "harpoon2",
-- 		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
-- 		config = function()
-- 			local harpoon = require("harpoon")
-- 			local conf = require("telescope.config").values
-- 
-- 			local function open_harpoon_picker()
-- 				local harpoon_files = harpoon:list()
-- 				local file_paths = {}
-- 
-- 				for _, item in ipairs(harpoon_files.items) do
-- 					table.insert(file_paths, item.value)
-- 				end
-- 
-- 				local function refresh_picker(current_picker)
-- 					local paths = {}
-- 					for _, item in ipairs(harpoon_files.items) do
-- 						table.insert(paths, item.value)
-- 					end
-- 
-- 					current_picker:refresh(require("telescope.finders").new_table({ results = paths }))
-- 				end
-- 
-- 				require("telescope.pickers")
-- 					.new({}, {
-- 						prompt_title = "Harpoon",
-- 						finder = require("telescope.finders").new_table({ results = file_paths }),
-- 						previewer = conf.file_previewer({}),
-- 						sorter = conf.generic_sorter({}),
-- 						layout_config = {
-- 							height = 0.4,
-- 							width = 0.7,
-- 						},
-- 						attach_mappings = function(prompt_bufnr, map_telescope)
-- 							map_telescope("i", "<C-d>", function()
-- 								local actions_state = require("telescope.actions.state")
-- 								local selected_entry = actions_state.get_selected_entry()
-- 								local current_picker = actions_state.get_current_picker(prompt_bufnr)
-- 
-- 								table.remove(harpoon_files.items, selected_entry.index)
-- 								refresh_picker(current_picker)
-- 							end)
-- 							return true
-- 						end,
-- 					})
-- 					:find()
-- 			end
-- 
-- 			harpoon:setup()
-- 
-- 			vim.keymap.set("n", "<leader>a", function()
-- 				harpoon:list():add()
-- 			end, { desc = "Add file to Harpoon" })
-- 			vim.keymap.set("n", "<leader>1", function()
-- 				harpoon:list():select(1)
-- 			end, { desc = "Open Harpoon file 1" })
-- 			vim.keymap.set("n", "<leader>2", function()
-- 				harpoon:list():select(2)
-- 			end, { desc = "Open Harpoon file 2" })
-- 			vim.keymap.set("n", "<leader>3", function()
-- 				harpoon:list():select(3)
-- 			end, { desc = "Open Harpoon file 3" })
-- 			vim.keymap.set("n", "<leader>4", function()
-- 				harpoon:list():select(4)
-- 			end, { desc = "Open Harpoon file 4" })
-- 			vim.keymap.set("n", "<leader>5", function()
-- 				harpoon:list():select(5)
-- 			end, { desc = "Open Harpoon file 5" })
-- 			vim.keymap.set("n", "<C-S-P>", function()
-- 				harpoon:list():prev()
-- 			end, { desc = "Previous harpoon file" })
-- 			vim.keymap.set("n", "<C-S-N>", function()
-- 				harpoon:list():next()
-- 			end, { desc = "Next harpoon file" })
-- 			vim.keymap.set("n", "<C-e>", open_harpoon_picker, { desc = "Open Harpoon picker" })
-- 
-- 			harpoon:extend({
-- 				UI_CREATE = function(cx)
-- 					vim.keymap.set("n", "<C-v>", function()
-- 						harpoon.ui:select_menu_item({ vsplit = true })
-- 					end, { buffer = cx.bufnr, desc = "Open in vertical split" })
-- 
-- 					vim.keymap.set("n", "<C-h>", function()
-- 						harpoon.ui:select_menu_item({ split = true })
-- 					end, { buffer = cx.bufnr, desc = "Open in horizontal split" })
-- 				end,
-- 			})
-- 		end,
-- 	},
}
