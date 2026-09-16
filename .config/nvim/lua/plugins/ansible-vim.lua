return {
	{
		"pearofducks/ansible-vim",
		-- Ansible syntax: YAML playbooks, jinja2 (.j2), hosts files.
		-- Pinned to eager loading on purpose: the plugin owns its own
		-- filetype detection (registers ft=yaml.ansible on BufRead), so
		-- lazy-loading it via `ft` is a chicken-and-egg (ft never gets set
		-- until the plugin is loaded). Cheap to load.
		lazy = false,
	},
}
