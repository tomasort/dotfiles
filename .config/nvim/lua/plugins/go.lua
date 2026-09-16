return {
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			-- { "nvim-treesitter/nvim-treesitter", branch = "main" } -- optional for master version
		},
		opts = {
			-- gopls inlay hints are managed by our own <leader>th toggle in
			-- lsp.lua; go.nvim's default `lsp_inlay_hints.enable = true`
			-- re-enables them globally (no bufnr filter) inside go.setup()
			-- every time the plugin loads, stomping your toggle.
			lsp_inlay_hints = { enable = false },
		},
		config = function(_, opts)
			require("go").setup(opts)
			local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					require("go.format").goimports()
				end,
				group = format_sync_grp,
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
}
