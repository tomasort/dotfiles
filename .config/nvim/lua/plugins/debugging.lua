-- Debugger: nvim-dap + python (debugpy, via uv) + integrated UI + inline
-- virtual-text values. Closest to the VS Code debugging experience.
return {
	{
		-- DAP UI: element windows (scopes, watches, breakpoints, REPL,
		-- console) docked like VS Code's debug sidebar
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()

			-- auto-open/close the debug UI with the session (vscode-like)
			dap.listeners.before.attach.dapui_config = dapui.open
			dap.listeners.before.launch.dapui_config = dapui.open
			dap.listeners.before.event_terminated.dapui_config = dapui.close
			dap.listeners.before.event_exited.dapui_config = dapui.close

			-- evaluated expression on hover / float (vscode-like)
			vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "Debug evaluate expression" })

			-- Session-scoped single-key stepping: only while a debug session
			-- is live, so the mappings can't interfere with normal editing
			-- (they exist buffer-locally during the session and vanish at end).
			--   ,  = step over   ·   .  = step into   ·   >  = step out
			--   C-n = continue to next breakpoint
			-- (NOTE: overrides dot-repeat/jump-motion *in the debug session
			-- only*; keys vanish on event_terminated/exited.)
			local session_maps = {
				{ { "n", "x" }, ",", dap.step_over, "Debug: step over" },
				{ { "n", "x" }, ".", dap.step_into, "Debug: step into" },
				{ { "n", "x" }, ">", dap.step_out, "Debug: step out" },
				{ { "n", "x" }, "<C-n>", dap.continue, "Debug: continue / next breakpoint" },
			}
			local mapped_bufs = {}
			local function clear_session_maps()
				for _, bufnr in ipairs(mapped_bufs) do
					for _, m in ipairs(session_maps) do
						pcall(vim.keymap.del, m[1], m[2], { buffer = bufnr })
					end
				end
				mapped_bufs = {}
			end
			dap.listeners.after.event_initialized["user_session_maps"] = function()
				local bufnr = vim.api.nvim_get_current_buf()
				if mapped_bufs[bufnr] ~= nil then
					return
				end
				mapped_bufs[#mapped_bufs + 1] = bufnr
				for _, m in ipairs(session_maps) do
					vim.keymap.set(m[1], m[2], m[3], { buffer = bufnr, desc = m[4], nowait = true })
				end
			end
			dap.listeners.before.event_terminated["user_session_maps"] = clear_session_maps
			dap.listeners.before.event_exited["user_session_maps"] = clear_session_maps

			-- breakpoint glyph (from the DAP guide article): subtle dot +
			-- a stop-position arrow; nvim-dap consumes legacy sign groups
			-- so highlighting via Diagnostic* groups stays consistent
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticInfo" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn" })

			-- Tool self-heal (kept as fallback for envs without mason/rust):
			-- codelldb/js-debug-adapter/delve install via mason-tool-installer
			-- (lsp.lua). If delve is missing here but go exists, bootstrap it
			-- directly (delve's mason package is a go-install scheme anyway).
			local function ensure_dlv()
				if vim.fn.executable("dlv") == 1 then
					return
				end
				if vim.fn.executable("go") ~= 1 then
					return
				end
				vim.notify("dlv not found — installing delve via go install (background)", vim.log.levels.INFO)
				vim.system({ "go", "install", "github.com/go-delve/delve/cmd/dlv@latest" }, { detach = true })
			end
			ensure_dlv()

			-- js/ts: vscode-js-debug via mason's js-debug-adapter package
			-- (install with :MasonInstall js-debug-adapter). NOTE: host and
			-- port must be explicit (127.0.0.1 + ${port}) or nvim-dap
			-- can't reach the spawned server (known gotcha)
			local js_adapter =
				vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
			if vim.uv.fs_stat(js_adapter) then
				dap.adapters["pwa-node"] = {
					type = "server",
					host = "127.0.0.1",
					port = "${port}",
					executable = {
						command = "node",
						args = { js_adapter, "${port}", "127.0.0.1" },
					},
				}
				for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
					dap.configurations[lang] = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = "${workspaceFolder}",
							sourceMaps = true,
							console = "integratedTerminal",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach to node process",
							processId = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
							sourceMaps = true,
						},
					}
				end

				-- browser debugging (Chrome/Edge): same adapter server; the
				-- adapter launches the browser itself with a debug port
				dap.adapters["pwa-chrome"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "node",
						args = { js_adapter, "${port}", "localhost" },
					},
				}
				for _, lang in ipairs({ "javascript", "javascriptreact" }) do
					table.insert(dap.configurations[lang], {
						type = "pwa-chrome",
						request = "launch",
						name = "Debug in Chrome",
						url = function()
							return vim.fn.input("URL to debug: ", "http://localhost:")
						end,
						webRoot = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						-- don't fail on missing sourcemaps
						sourceMapPathOverrides = {},
						runtimeExecutable = "chrome", -- uses the default browser launcher
					})
				end
			end

			-- C/C++ via codelldb (mason package, bundles lldb). Install with
			-- :MasonInstall codelldb. Needs a compiled binary with debug info:
			--   cc -g -O0 program.c -o program
			local codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
			if vim.uv.fs_stat(codelldb) then
				dap.adapters.codelldb = {
					type = "server",
					port = "${port}",
					executable = {
						command = codelldb,
						args = { "--port", "${port}" },
					},
				}
				for _, lang in ipairs({ "c", "cpp", "objc", "objcpp", "rust" }) do
					dap.configurations[lang] = dap.configurations[lang] or {}
					table.insert(dap.configurations[lang], {
						type = "codelldb",
						request = "launch",
						name = "Launch binary (codelldb)",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
					})
				end
			end

			-- session control keys (also valid *while stopped* in insert mode)
			local map = vim.keymap.set
			map("n", "<leader>dc", dap.continue, { desc = "Debug continue / pick config" })
			map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug toggle breakpoint" })
			map("n", "<leader>di", dap.step_into, { desc = "Debug step into" })
			map("n", "<leader>dk", dap.step_over, { desc = "Debug step over" })
			map("n", "<leader>do", dap.step_out, { desc = "Debug step out" })
			map("n", "<leader>dB", dap.clear_breakpoints, { desc = "Debug clear all breakpoints" })
			map("n", "<leader>dR", dap.restart, { desc = "Debug restart session" })
			map("n", "<leader>dq", dap.terminate, { desc = "Debug terminate session" })
			map("n", "<leader>dr", dapui.toggle, { desc = "Debug toggle UI" })
			map("n", "<leader>dL", dap.repl.open, { desc = "Debug open REPL" })
			-- re-run the last debug config without the picker (DAP article):
			-- no active session needed, unlike <leader>dR restart
			map("n", "<leader>dl", dap.run_last, { desc = "Debug run last configuration" })
			-- conditional breakpoint: prompts for the condition (DAP article)
			map("n", "<leader>dC", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug conditional breakpoint" })

			-- NOTE: getting out of a terminal buffer (dap terminal runs
			-- input()-style programs): press <C-\><C-n> — builtin Neovim
			-- terminal-mode exit → normal mode; "backslash then N" = N for
			-- [N]ormal. Then Ctrl-w h/l jumps back to the code window.
		end,
	},
	{
		-- inline virtual-text: variable values shown on the line at the
		-- breakpoint, like VS Code's inline variable display
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		opts = { commented = true },
	},
	{
		-- python: registers debugpy adapter + default launch/attach configs
		-- and pytest/unittest test debugging. `setup("uv")` provisions
		-- debugpy implicitly through uv — no manual venv dance needed, and
		-- nothing to bootstrap: uv handles installation per-project demand.
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-python").setup("uv")
		end,
		keys = {
			{ "<leader>dm", function() require("dap-python").test_method() end, ft = "python", desc = "Debug nearest test method" },
			{ "<leader>dM", function() require("dap-python").test_class() end, ft = "python", desc = "Debug nearest test class" },
		},
	},
	{
		-- go: delve adapter + default launch/attach configs + test debugging
		-- (dlv binary via brew install delve)
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-go").setup({})
		end,
		keys = {
			{ "<leader>dm", function() require("dap-go").debug_test() end, ft = "go", desc = "Debug nearest go test" },
			{ "<leader>dM", function() require("dap-go").debug_last_test() end, ft = "go", desc = "Debug last go test" },
		},
	},
}
