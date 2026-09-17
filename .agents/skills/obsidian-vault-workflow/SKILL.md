---
name: obsidian-vault-workflow
description: >
  Work safely inside an Obsidian vault by following existing folder structure, frontmatter,
  note-linking, and index-note conventions. Use this when creating, editing, organizing, or
  curating Markdown notes in a user's Obsidian vault.
license: MIT
---

# Obsidian Vault Workflow

Use this skill when the task is about **working in a real Obsidian vault as a file tree**, not
just writing generic Obsidian syntax.

This skill complements generic skills such as:

- `obsidian-markdown` for Obsidian-flavored Markdown syntax
- `obsidian-bases` for `.base` files
- `json-canvas` for `.canvas` files
- `obsidian-cli` for actions that require a running Obsidian app

## Default behavior

1. **Find the vault root first.**
   - Prefer a user-provided vault path.
   - Otherwise, look for a folder containing `.obsidian/`.
   - If multiple vaults are possible and the target is ambiguous, ask the user.

2. **Inspect before editing.**
   - Read nearby notes and folders before creating new files.
   - Infer the vault's conventions from existing content instead of inventing a new structure.

3. **Preserve local conventions.**
   - Follow the existing folder layout.
   - Match note naming style already used in the vault.
   - Reuse frontmatter keys already present in similar notes.
   - Preserve tag style, alias style, and wikilink style already in use.

4. **Prefer minimal, local changes.**
   - Update the smallest relevant set of notes.
   - Do not reorganize large sections of the vault unless the user explicitly asks.

## Workflow

When asked to work in an Obsidian vault:

1. Identify the target vault and the relevant note or folder.
2. Inspect similar notes to learn the vault's structure and metadata conventions.
3. If templates exist, prefer them over inventing a new format.
4. Create or edit the target note using valid Obsidian Markdown.
5. Add or maintain relevant `[[wikilinks]]` to related notes.
6. If the vault appears to use MOCs, index notes, dashboards, or folder overviews, update them
   when the new note clearly belongs there.
7. Preserve frontmatter order and existing keys where practical.
8. Avoid breaking existing links, embeds, and references.

## Things to inspect before creating notes

- whether the vault has a `Templates`, `template`, or `Templater` folder
- whether daily notes live in a dedicated folder
- whether projects, people, books, or topics have consistent folder placement
- whether notes commonly use properties such as `tags`, `aliases`, `status`, `created`, `updated`,
  `source`, or `cssclasses`
- whether index notes or MOCs exist and should be updated

## Rules

- Prefer editing Markdown files directly unless the task specifically requires a running Obsidian
  app or the `obsidian` CLI.
- Do not modify `.obsidian/` configuration files unless the user asks for config changes.
- Do not rename or move large groups of notes without explicit instruction.
- Do not replace `[[wikilinks]]` with Markdown links for internal notes.
- If a folder or note naming decision is unclear, ask instead of guessing.

## Common patterns

### Creating a new note

1. Find the best folder by inspecting similar notes.
2. Match the vault's title and filename style.
3. Reuse the frontmatter schema from related notes.
4. Add links to existing related notes.
5. Update an index note or MOC if the vault uses one.

### Updating an existing note

1. Preserve existing frontmatter unless the task requires changing it.
2. Keep the author's structure and headings when possible.
3. Add new sections in the style already used in the note.
4. Maintain backlinks by linking to related notes where appropriate.

### Working with daily notes

1. Detect the date format already used by the vault.
2. Write into the current daily note if one exists.
3. If creating a daily note, match the vault's filename and template conventions.

## Output expectations

When you finish, clearly say:

- which vault or path you used
- which files you created or changed
- whether any index or MOC notes were updated
