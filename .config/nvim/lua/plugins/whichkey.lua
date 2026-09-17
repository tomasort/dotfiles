return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			-- Delay (ms) before the which-key popup appears after you type a
			-- prefix; keep typing fast prefixes without the menu flashing
			delay = 500,
			spec = {
				{ "<leader>q", group = "SQL / Database (Queries)" }, -- which-key needs a group to show prefixed keys
				-- { "<leader>S", group = "SQL / Database" }, -- S-group removed: zz case-sensitive capital S in group makes chords shift-race error-prone
				-- { "<leader>c", group = "Code" },
				-- { "<leader>d", group = "Debug" },
				-- { "<leader>f", group = "Files" },
				-- { "<leader>g", group = "Git (hunks + LazyGit/Diffview)" },
				-- { "<leader>G", group = "Git (fugitive repo-level)" },
				-- { "<leader>o", group = "AI" },
				-- { "<leader>p", group = "Plugins" },
				-- { "<leader>t", group = "Search" },
				-- { "<leader>v", group = "Workspace" },
				-- { "<leader>z", group = "Terminal" },
				-- { "<leader>x", group = "Diagnostics" },
			},
		},
	},
}
