return {
	{
		"ThePrimeagen/harpoon",
		enabled = true,
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
		config = function()
			local harpoon = require("harpoon")
			local fzf = require("fzf-lua")

			harpoon:setup()

			-- fzf-lua powered Harpoon picker (replaces the old Telescope one).
			-- Same UX as before: <C-e> opens it, <C-d> deletes in-place,
			-- <C-v>/<C-h> open splits. Delete rebuilds the list and reopens.
			local function open_harpoon_picker()
				local harpoon_files = harpoon:list()

				local function paths()
					local out = {}
					for _, item in ipairs(harpoon_files.items) do
						table.insert(out, item.value)
					end
					return out
				end

				local function find_index(path)
					-- fzf echoes the entry back verbatim, but normalize in case
					-- harpoon stores e.g. ./ prefixed paths
					local norm = vim.fs.normalize(path)
					for i, item in ipairs(harpoon_files.items) do
						if vim.fs.normalize(item.value) == norm then
							return i
						end
					end
				end

				local function open(path, split)
					local i = find_index(path)
					if i then
						if split == "vsplit" then
							harpoon_files:select(i, { vsplit = true })
						elseif split == "h" then
							harpoon_files:select(i, { split = true })
						else
							harpoon_files:select(i)
						end
					end
				end

				-- keymap hint via fzf-lua's native actions header (same style
				-- as the builtin pickers); plain function actions without a
				-- `header` label are skipped from it
				fzf.fzf_exec(paths(), {
					prompt = "Harpoon❯ ",
					previewer = "builtin",
					winopts = { height = 0.5, width = 0.7 },
					_headers = { "actions" },
					actions = {
						["default"] = function(selected)
							open(selected[1])
						end,
						["ctrl-v"] = {
							fn = function(selected)
								open(selected[1], "v")
							end,
							header = "vsplit",
						},
						["ctrl-s"] = {
							fn = function(selected)
								open(selected[1], "h")
							end,
							header = "split",
						},
						-- delete from the list, then reopen so the list refreshes
						["ctrl-d"] = {
							fn = function(selected)
								local i = find_index(selected[1])
								if i then
									harpoon_files:remove_at(i)
								end
								open_harpoon_picker()
							end,
							header = "delete",
						},
					},
				})
			end

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Add file to Harpoon" })
			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end, { desc = "Open Harpoon file 1" })
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end, { desc = "Open Harpoon file 2" })
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end, { desc = "Open Harpoon file 3" })
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end, { desc = "Open Harpoon file 4" })
			vim.keymap.set("n", "<leader>5", function()
				harpoon:list():select(5)
			end, { desc = "Open Harpoon file 5" })
			vim.keymap.set("n", "<C-e>", open_harpoon_picker, { desc = "Open Harpoon picker" })
		end,
	},
}
