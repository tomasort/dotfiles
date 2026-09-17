---
name: obsidian-kanban
description: >
  Create and edit Obsidian Kanban board files for the obsidian-kanban plugin. Use this when the
  user wants to add, move, rename, archive, or inspect lists and cards on a Kanban board inside an
  Obsidian vault.
license: MIT
---

# Obsidian Kanban

Use this skill when working with boards backed by the `obsidian-kanban` plugin.

This plugin stores boards as Markdown files, not a separate binary format. That means cards and
lists can be edited directly, as long as the board structure is preserved.

## What I do

- Create new Kanban board notes that are compatible with the Obsidian Kanban plugin.
- Add, remove, rename, move, and reorder lists.
- Add, edit, move, archive, and remove cards.
- Help interpret a board when the user asks about a specific list or card.
- Preserve the plugin settings block and board structure so Obsidian keeps rendering the file as a board.

## When to use me

- The user mentions the Obsidian Kanban plugin.
- The user wants help with a Kanban board, column, lane, list, card, or archive.
- The task involves editing a Markdown note that represents a Kanban board.

## Board format

Obsidian Kanban boards are Markdown files that typically contain:

1. A YAML frontmatter block at the top, if the note already uses one.
2. A line containing `kanban-plugin: basic`.
3. One or more list headings using `## List Name`.
4. Cards under each list as Markdown task items such as `- [ ] Card title`.
5. An optional `## Archive` section.
6. A trailing settings block in this exact pattern:

```md
%% kanban:settings
```
{...json settings...}
```
%%
```

Treat the settings block as plugin data. Preserve it exactly unless the user explicitly asks for a settings change.

## Rules

- Find the target vault first and inspect the existing board before editing it.
- Prefer minimal edits to the relevant board file only.
- Preserve existing frontmatter, tags, wikilinks, dates, and inline metadata on cards.
- Do not modify `.obsidian/` plugin config unless the user explicitly asks.
- Do not rewrite the whole board if a small targeted edit is enough.
- Do not remove the `kanban-plugin: basic` marker or the `%% kanban:settings` block.
- If multiple cards have the same text and the target is ambiguous, ask a short clarifying question.
- If the board format is unusual or appears corrupted, stop and explain the risk before changing it.

## Workflow

1. Identify the target vault and board note.
2. Read the full board file before editing.
3. Preserve the file's overall order:
   - frontmatter if present
   - kanban marker
   - lists and cards
   - archive section if present
   - kanban settings block
4. Make the smallest possible edit:
   - add a card under the requested list
   - move a card from one list heading to another
   - rename the matching list heading
   - add a new list heading in a sensible nearby position
5. Keep card syntax as Markdown task items unless the board clearly uses another supported pattern.
6. Re-read the edited file and confirm the marker and settings block still exist.
7. Report which board file changed and what lists or cards were updated.

## Common patterns

### Add a card to a list

Insert a new task item under the requested `## List Name` heading:

```md
## Todo

- [ ] Follow up with recruiter
```

### Move a card between lists

Remove the card line from the source list and insert the same line into the destination list.

### Create a new list

Add a new `## List Name` heading near related lists and leave a blank line before the first card.

### Archive a completed card

If the board already has `## Archive`, move the card there.
If it does not, ask whether to create an archive section unless the user explicitly asked you to archive all completed cards.

## Interpreting specific elements

When the user asks about a specific Kanban element:

- A board: summarize its lists, card counts, and notable archived items.
- A list: summarize the cards in that list.
- A card: show its exact text, location, and any inline metadata, dates, tags, or links.

## Example requests

- "Add a card to my interview prep board for practicing system design."
- "Move the Airbnb application card from Applied to Interviewing."
- "Rename the Doing column to In Progress in my job search board."
- "What is in the Waiting list on my applications kanban?"
- "Create a kanban board for my job search inside the Obsidian vault."

## Output expectations

When you finish, clearly say:

- which vault path you used
- which board file you created or changed
- what lists or cards were added, moved, renamed, archived, or removed
