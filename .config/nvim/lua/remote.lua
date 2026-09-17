-- Remote UI: pick an ssh host (from ~/.ssh/config, or type one), pick a remote
-- directory, then attach a local Neovim UI to a Neovim editor running on that
-- host (see ~/.local/bin/nvim-remote).
--
-- The remote instance owns the buffers, plugins and LSP; this machine only
-- renders the UI and forwards keys, so the experience is close to VS Code
-- Remote-SSH. Requires nvim on the remote host and `--remote-ui` support
-- locally (Neovim 0.10+).
local M = {}

local function ssh_config_hosts()
	local hosts, seen = {}, {}
	local f = io.open(vim.fn.expand("~/.ssh/config"), "r")
	if not f then
		return hosts
	end
	for line in f:lines() do
		local names = line:match("^%s*[Hh]ost%s+(.+)$")
		if names then
			for name in names:gmatch("%S+") do
				if not name:find("[%*%?!]") and not seen[name] then
					seen[name] = true
					hosts[#hosts + 1] = name
				end
			end
		end
	end
	f:close()
	table.sort(hosts)
	return hosts
end

local function ui_input(prompt, default, cb)
	-- goes through snacks.nvim's floating, centered input window when its
	-- `input` module is enabled, falling back to the command line otherwise
	vim.ui.input({ prompt = prompt, default = default }, function(value)
		cb(value and value ~= "" and value or nil)
	end)
end

local function pick(items, prompt, cb)
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		ui_input(prompt, items[1], cb)
		return
	end
	fzf.fzf_exec(items, {
		prompt = prompt .. "> ",
		actions = {
			["default"] = function(selected)
				cb(selected and selected[1] or nil)
			end,
		},
	})
end

local function remote_dirs(host)
	local cmd = string.format(
		"ssh -o BatchMode=yes %q 'fd -t d -d 2 . \"$HOME\" 2>/dev/null || find \"$HOME\" -maxdepth 2 -type d 2>/dev/null'",
		host
	)
	local out = vim.fn.systemlist(cmd)
	-- keep only directories that actually exist remotely (systemlist returns an
	-- error line when the ssh call fails)
	if vim.v.shell_error ~= 0 or #out == 0 then
		return {}
	end
	local dirs = {}
	for _, d in ipairs(out) do
		if d ~= "" then
			if d:sub(1, 1) ~= "/" then
				d = "$HOME/" .. d
			end
			dirs[#dirs + 1] = d
		end
	end
	return dirs
end

local function attach(host, dir)
	local args = { "nvim-remote", host, dir }
	local cmd = table.concat(vim.tbl_map(vim.fn.shellescape, args), " ")

	if vim.env.TMUX then
		vim.fn.system({ "tmux", "new-window", "-n", "nvim:" .. host, cmd })
		return
	end

	vim.notify(
		"nvim-remote: not inside tmux, run this in another terminal:\n  " .. cmd,
		vim.log.levels.INFO
	)
end

function M.pick()
	local function attach_flow(host, dir)
		if not host or host == "" then
			return
		end
		local dirs = remote_dirs(host)
		dirs[#dirs + 1] = "✎ type a path manually…"

		pick(dirs, "remote dir", function(dir)
			if not dir then
				return
			end
			if dir:find("^✎") then
				ui_input("remote dir [$HOME]: ", "$HOME", function(typed)
					attach(host, typed or "$HOME")
				end)
			else
				attach(host, dir)
			end
		end)
	end

	local hosts = ssh_config_hosts()
	hosts[#hosts + 1] = "✎ type a host manually…"

	pick(hosts, "ssh host", function(host)
		if not host then
			return
		end
		if host:find("^✎") then
			ui_input("ssh host (user@ip): ", nil, function(typed)
				attach_flow(typed, nil)
			end)
		else
			attach_flow(host, nil)
		end
	end)
end

vim.api.nvim_create_user_command("RemoteUI", function()
	M.pick()
end, { desc = "Attach a local Neovim UI to a remote nvim (fzf-lua host picker)" })

return M
