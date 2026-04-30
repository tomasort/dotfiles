# Repository context

This repository is a personal dotfiles tree installed with GNU Stow. Top-level paths mirror their home-directory destinations (`.zshrc`, `.tmux.conf`, `.config/...`); keep that structure intact so Stow can link files without extra glue.

`remove_conflicting_files.sh` backs up conflicting non-symlink files in `$HOME` before linking. `.stow-local-ignore` defines what Stow should skip, so generated, backup, and VCS artifacts stay out of the tree.

# Commands

- Stow a package from the repo root: `stow <directory_name>`
- Stow to a specific target: `stow -t <target_directory> <directory_name>`
- Dry-run Stow: `stow -n <directory_name>`
- Back up conflicts before linking: `bash remove_conflicting_files.sh`
- Neovim plugin management uses `lazy.nvim`: `:Lazy install`, `:Lazy update`, `:Lazy clean`
- Neovim formatting helpers: `:Format`, `:FormatToggle`

# Neovim layout

- `.config/nvim/init.lua` is the main entrypoint for Neovim. It bootstraps `lazy.nvim` and loads `plugins/*` plus `config/*`.
- `lua/config/keymaps.lua` is the single home for user-facing keymaps. Put new normal/insert/terminal maps there, including buffer-local maps via autocmds. Prefer direct `vim.keymap.set(...)` calls over `map`/`nmap` helper aliases. Plugin-owned UI mappings may live in plugin modules when that is the natural ownership boundary.
- `lua/config/lsp.lua` owns LSP servers, Mason, completion, diagnostics, and related setup. Keep LSP keymaps out of it.
- `lua/config/tooling.lua` owns formatter and linter setup.
- `lua/config/filetypes.lua` owns filetype detection and overrides.
- `lua/config/telescope.lua` owns telescope defaults and extensions.
- `lua/config/treesitter.lua` owns tree-sitter parser setup.
- `lua/config/debugging.lua` owns DAP setup only.

# Plugin file naming

- `ui.lua`: colorscheme, statusline, window/UI polish, diagnostics presentation, which-key, trouble, markdown rendering, indent guides.
- `editor.lua`: navigation and editing workflow plugins such as Oil, FZF/Telescope, file tree, terminal, Harpoon, git UI, diff views, undo tree, tmux integration.
- `coding.lua`: comment/surround/autopairs/snippets, TODO navigation, and other editing helpers.
- `ai.lua`: OpenCode, Copilot, CopilotChat, and related AI helpers.
- `lang.lua`: language-specific plugins that are not LSP itself, such as VimTeX or filetype helpers.
- `lsp.lua`: plugin declarations for Mason, LSP, completion, formatters, linters, and rename tooling.
- `treesitter.lua`: tree-sitter and tree-based text features.
- `debugging.lua`: DAP and debugger UI plugins.

If a concern does not fit one of those buckets, create a new feature-named file instead of turning an existing module into a grab bag.

# Fallback Vim

`.vimrc` is the basic Vim compatibility layer. Keep it focused on core Vim settings and fallback mappings so a plain Vim session still works. Neovim-specific plugin, LSP, and UI behavior belongs in `.config/nvim/init.lua` and its modules.

# Conventions

- Keep the tree mirrored to home paths; do not flatten it.
- Use Stow for dotfiles and `lazy.nvim` for Neovim plugins.
- Keep shared runtime behavior in `lua/config/*.lua` and plugin declarations in `lua/plugins/*.lua`.
- Keep formatter/linter mappings aligned with `config/tooling.lua` (`stylua`, `isort`/`black`, `goimports`/`gofumpt`, `shfmt`, `shellcheck`, `ruff`, `golangci-lint`, `chktex`).
- Avoid hand-editing generated or stateful files unless necessary, especially `lazy-lock.json`, `hosts.yml`, and prompt wizard output.
