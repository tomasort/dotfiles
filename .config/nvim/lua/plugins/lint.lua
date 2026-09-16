return {
	{
		"mfussenegger/nvim-lint",
		-- Load lazily; autocmds below handle the rest of the lifecycle
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				lua = { "luacheck" },
				python = { "ruff" },
				go = { "golangcilint" },
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				tex = { "chktex" },
				["yaml.ansible"] = { "ansible_lint" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("user_nvim_lint", { clear = true }),
				callback = function(args)
					-- Skip read-only/scratch buffers; re-lint on every edit event
					if vim.bo[args.buf].modifiable and vim.bo[args.buf].buftype == "" then
						lint.try_lint()
					end
				end,
			})
		end,
	},
}
