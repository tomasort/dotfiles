#!/usr/bin/env bash
# Update every updatable agent-skill family. Review the resulting diffs afterwards:
#   cd ~/dotfiles && git status
# Changes to vendored skills land in the dotfiles repo; the submodule needs a
# pointer commit; the package-managed tools update in place.
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

step() { printf '\n\033[1m==> %s\033[0m\n' "$1"; }

step "Vendored skills via skills CLI (.skill-lock.json tracked skills)"
npx -y skills@latest update -g -y || true

step "Vendored skills not lock-tracked (defuddle, json-canvas, obsidian-*)"
echo "NOTE: re-run 'npx skills add <repo> -g -a opencode -y' for any of these if you want newer versions; skipping in bulk."

step "Hyperframes skills"
npx -y hyperframes@latest skills update

step "diagram-design submodule"
git -C "$DOTFILES" submodule update --remote externals/diagram-design

step "ponytail opencode plugin"
npm install -g @dietrichgebert/ponytail@latest || true

step "open-code-review CLI"
npm install -g @alibaba-group/open-code-review@latest || true

step "Done"
echo "next: review + commit changes in the dotfiles repo (git -C $DOTFILES status)"
