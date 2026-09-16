-- Ansible vault helper commands (opt-in, no automatic decrypt):
--   :AnsibleVaultView — show the current *whole-file* vault in a read-only
--                       scratch buffer (file on disk stays encrypted)
--   :AnsibleVaultEdit — decrypt the current buffer IN PLACE and re-encrypt it
--                       back automatically on write
-- Both shell out to ansible-vault using the vault password file that
-- ansible.cfg already points at (~/ansible/vault.txt), so no password prompts.
-- Only whole-file vaults are supported ($ANSIBLE_VAULT;… first line); inline
-- `!vault |` yaml values are out of scope.
local function vault_password_file()
	local pwf = vim.fn.expand("~/ansible/vault.txt")
	if vim.uv.fs_stat(pwf) then
		return pwf
	end
	return nil
end

local function is_whole_file_vault(bufnr)
	local first = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
	return first:match("^%$ANSIBLE_VAULT;") ~= nil
end

vim.api.nvim_create_user_command("AnsibleVaultView", function()
	local fpath = vim.api.nvim_buf_get_name(0)
	if fpath == "" or not vim.uv.fs_stat(fpath) then
		vim.notify("AnsibleVaultView: current buffer is not a file on disk", vim.log.levels.WARN)
		return
	end
	local pwf = vault_password_file()
	if not pwf then
		vim.notify("AnsibleVaultView: vault password file not found (~/ansible/vault.txt)", vim.log.levels.ERROR)
		return
	end

	local content = vim.fn.system({
		"ansible-vault", "view", fpath,
	})
	if vim.v.shell_error ~= 0 then
		vim.notify("ansible-vault view failed: " .. (content or ""), vim.log.levels.ERROR)
		return
	end

	local lines = vim.split(vim.trim(content), "\n")

	local scratch = vim.api.nvim_create_buf(false, true)
	vim.bo[scratch].bufhidden = "wipe"
	vim.bo[scratch].buftype = "nofile"
	vim.bo[scratch].swapfile = false
	vim.bo[scratch].undofile = false
	vim.api.nvim_buf_set_lines(scratch, 0, -1, false, lines)
	vim.bo[scratch].filetype = "yaml"
	vim.bo[scratch].modifiable = false

	vim.cmd("botright vsplit")
	vim.api.nvim_win_set_buf(0, scratch)
	vim.keymap.set("n", "q", ":close<CR>", { buffer = scratch, nowait = true, desc = "Close vault view" })
end, { desc = "View the current whole-file vault in a read-only scratch buffer" })

vim.api.nvim_create_user_command("AnsibleVaultEdit", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local fpath = vim.api.nvim_buf_get_name(bufnr)
	if fpath == "" or not vim.uv.fs_stat(fpath) then
		vim.notify("AnsibleVaultEdit: current buffer is not a file on disk", vim.log.levels.WARN)
		return
	end
	if not is_whole_file_vault(bufnr) then
		vim.notify("AnsibleVaultEdit: not a whole-file vault ($ANSIBLE_VAULT; header missing)", vim.log.levels.WARN)
		return
	end
	local pwf = vault_password_file()
	if not pwf then
		vim.notify("AnsibleVaultEdit: vault password file not found (~/ansible/vault.txt)", vim.log.levels.ERROR)
		return
	end

	-- safety: no on-disk / in-editor traces of the plaintext session
	vim.bo[bufnr].swapfile = false
	vim.opt_local.undofile = false

	vim.cmd("silent! %!ansible-vault decrypt")
	if vim.v.shell_error ~= 0 then
		vim.notify("AnsibleVaultEdit: decrypt failed", vim.log.levels.ERROR)
		return
	end

	-- on write: encrypt back before hitting disk…
	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		group = vim.api.nvim_create_augroup("user_ansible_vault_wpre", { clear = false }),
		callback = function()
			vim.cmd("silent! %!ansible-vault encrypt")
		end,
	})
	-- …and pop back to the decrypted viewing state immediately after the write
	vim.api.nvim_create_autocmd("BufWritePost", {
		buffer = bufnr,
		group = vim.api.nvim_create_augroup("user_ansible_vault_wpost", { clear = false }),
		callback = function()
			vim.cmd("silent! undo")
		end,
	})

	vim.notify("AnsibleVaultEdit: decrypted in place (re-encrypts automatically on :w)", vim.log.levels.INFO)
end, { desc = "Decrypt the current vault file for editing (auto re-encrypt on write)" })

return {}
