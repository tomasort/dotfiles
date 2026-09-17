---
name: anki-cards
description: >
  Skill for the full Anki flashcard workflow — creating, updating, managing, and reviewing
  Anki cards. Use this when the user asks to add cards to Anki, create flashcards, improve
  existing Anki cards, manage Anki decks, study/review with Anki, change card styles or note
  types, or anything related to Anki flashcard management.
allowed-tools: shell
---

# Anki Card Management Skill

You help the user create, update, manage, and **review** Anki flashcards. You have **two
interfaces** to Anki, and the card-style intelligence (note types, writing guidelines)
applies identically to both:

## Two Interfaces — pick one

| | **AnkiConnect (anki-mcp tools)** | **`anki` Python library** |
|---|---|---|
| Anki must be | **Running** (AnkiConnect addon on port 8765) | **Closed** |
| Reachability check | `curl -s -m 3 -X POST http://localhost:8765 -d '{"action":"version","version":6}'` → returns a version | process check below |
| Best for | Review/study sessions, live note editing, GUI operations, media import, tags, stats, model/template styling | Large batch imports, complex multi-field card creation, anything needing deep collection access |
| Speed | Near-instant per call (no Anki restart) | Fast batch, but requires Anki fully quit |
| Card styles | Select note type **by name** (`addNote`/`addNotes` model) | Select note type **by ID** |

**Selection rule:**
1. **Review / study sessions** (`present_card`, `rate_card`, due cards) → **must** use AnkiConnect (MCP). Anki is running by definition.
2. **Anki is running** (AnkiConnect reachable) → prefer **AnkiConnect/MCP tools**. No need to quit Anki.
3. **Anki is closed** → use the **`anki` Python library** (direct DB access).
4. For **large batch creation** when Anki is closed, the Python library is usually cleaner; when Anki is running, use `addNotes` (up to 100 notes, partial success supported).

Both interfaces are read/write. Never mix direct SQLite writes with either.

## Environment

- **Anki collection path:** `/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2`
- **Python with anki library:** Use `python3.9` (the `anki` pip package is installed here)
- **AnkiConnect:** addon `2055492159`, endpoint `http://localhost:8765`, API version 6
- **Anki MCP server:** `anki-mcp` (via `npx @ankimcp/anki-mcp-server --stdio`), exposes the tools below

## Critical Rules

1. **Python-library access requires Anki to be closed.** Always check first:
   ```bash
   ps aux | grep -i "anki.app" | grep -v grep | grep -v voicebanking
   ```
   If Anki is running, prefer AnkiConnect tools; only ask the user to quit (Cmd+Q) if you must
   use the Python library (e.g., large batch import).

2. **Do not remove WAL/SHM files by default.** Only remove them if they appear to be stale and
   Anki has already been confirmed closed. Prefer leaving them alone unless access to the
   collection fails or you have a concrete reason to believe they were left behind by a crash.
   When cleanup is needed, use:
   ```bash
   rm -f "/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2-wal" \
         "/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2-shm"
   ```

3. **Always use a supported interface** — the `anki` Python library or the AnkiConnect API —
   never modify the SQLite database directly. Direct SQLite writes corrupt the database because
   Anki uses checksums and internal bookkeeping.

4. **Always close the collection** when done with the Python library (`col.close()`).

5. **updateNoteFields caveat:** when using the MCP `updateNoteFields`, do **not** have the note
   open in Anki's Browser at the same time, or the update silently fails (upstream AnkiConnect
   limitation). Close the browser / switch notes first.

6. **deleteNotes safety:** `deleteNotes` requires explicit `confirmDeletion: true`. Deleting a
   note removes all its cards permanently.

## Note Types Reference

Available note types. **The Python library references them by ID; AnkiConnect references them
by name.** Both resolve to the same note types.

| Note Type (name) | Python ID | Fields | Use When |
|---|---|---|---|
| `Basic` | `1474753065065` | Front, Back | One-way: open-ended explanations, procedural "how do you…" questions, or answers too long to be useful prompts |
| `Basic (and reversed card)` | `1474753065064` | Front, Back | Two-way: term ↔ definition, tag ↔ description, concept ↔ formula |
| `Basic (type in the answer)` | `1534963187027` | Front, Back, More info | CLI commands, function signatures, exact syntax — user must **type** the answer |
| `Basic (multiline type in the answer and more)` | `1593528272757` | Front, Back, More | Multi-line code blocks or commands the user must type |
| `Basic (type in the answer and more)` | `1591574768074` | Front, Back | Simpler type-in-the-answer without extra info field |
| `Basic (and reverse and more)` | `1593178485121` | Front, Back, More | Two-way cards with extra info |
| `Basic_code` | `1509511317335` | Question, Answer, Code Block, Examples | Code-related questions with syntax-highlighted code blocks and examples |
| `Code output question` | `1389083022927` | Code, Output | "What does this code output?" — show code, user predicts output |
| `CommandQuestion` | `1581571617476` | Command, Back | Single CLI commands |
| `Cloze` | `1474753065059` | Text, Extra | Fill-in-the-blank factual recall (use `{{c1::answer}}` syntax) |
| `latex back` | `1631863082334` | Front, Back | Math questions where the back side renders LaTeX |
| `latex front & back` | `1631863428212` | Front, Back | Math questions with LaTeX rendering on both sides |

> When unsure of exact names, call `modelNames` (MCP) or list models via the Python library.
> Cloze and reversed cards render the correct direction automatically per their templates —
> no special handling needed.

### Note Type Decision Guide

When creating cards, follow this priority order to pick the best note type:

1. **Is it a command, function signature, or exact syntax the user should memorize?**
   → Use `Basic (type in the answer)` or `CommandQuestion`. Forcing recall by typing dramatically improves retention of commands.
   - Docker commands, git commands, shell commands, Python function signatures, regex syntax
   - Put any extra explanation in the "More info" field

2. **Is it a multi-line command or code block to type?**
   → Use `Basic (multiline type in the answer and more)`

3. **Is it "what does this code output?"**
   → Use `Code output question`. Put the code in the Code field and expected output in the Output field.

4. **Is it a code-related explanation question with syntax-highlighted examples?**
   → Use `Basic_code`. Fill all fields: Question, Answer, Code Block, Examples.

5. **Is it a fill-in-the-blank factual recall?**
   → Use `Cloze`. Wrap answers in `{{c1::...}}` (or `{{c2::...}}` for related blanks).

6. **Is it a LaTeX-heavy math question?**
   → Use `latex front & back` if both sides need LaTeX, or `latex back` if only the answer does.

7. **Is it a bidirectional concept (works both ways)?**
   → Use `Basic (and reversed card)`. Good for: term ↔ definition, tag ↔ description, concept ↔ formula.

8. **Otherwise (one-way, open-ended, or long answer)**
   → Use `Basic`.

## Card Writing Guidelines

When creating flashcard content, follow these principles for effective learning (applies to
**both** interfaces):

### Front (Question) Side
- **Always phrase as a clear question** — never just a bare term or phrase.
- **Include the topic/domain context** so the card is self-contained and can live in any deck.
  - ✅ "In a regular expression, what symbol matches the start of the string?"
  - ❌ "Match start of string"
  - ✅ "In Python, what does the `enumerate()` function return?"
  - ❌ "enumerate()"
- **Use bold `<b>` for the key concept** being tested.
- **One concept per card** — don't bundle multiple questions.

### Back (Answer) Side
- **Start with a concise, direct answer** to the question.
- **Include a practical example** where applicable.
- **Use HTML formatting** for readability (`<b>`, `<i>`, `<code>`, `<br />`).
- **For "what tag/symbol" cards**, start the back with the subject context:
  - e.g. "HTML tag that defines..." or the symbol/syntax followed by explanation.

### Cloze-Specific Guidelines
- Use `{{c1::...}}` for all related blanks (they reveal together).
- Use `{{c1::...}}` and `{{c2::...}}` for independent blanks.
- Keep the sentence readable without the blanks filled in.

### Type-in-the-Answer Guidelines
- Make the question specific enough that there's exactly one correct answer.
- Include context hints like "In Python, ..." or "What git command ..."
- Put any extra explanation, examples, or notes in the "More info" field.

## AnkiConnect Interface (anki-mcp tools)

Use these MCP tools when Anki is running. All content decisions (note type, card style,
HTML formatting) still follow the Note Type Decision Guide and Card Writing Guidelines above.

### Review & Study workflow

The canonical review flow — drive it like a tutor:

1. **Prep:** `sync` (pull latest / push changes) and optionally `collection_stats` / `review_stats` to know what's due.
2. **Pull due cards:** `get_due_cards` (filter by `deck` if requested), or `get_cards` by state (`due`, `new`, `learning`, `suspended`, `buried`).
3. **Present each card:** `present_card` — show the question/front. Explain hints, give context, let the user answer.
4. **Rate:** `rate_card` with the user's choice (Again / Hard / Good / Easy).

`present_card` renders the card exactly as Anki shows it, so reversed and cloze cards display
the correct direction automatically.

### Creating cards (Anki running)

- `listDecks` → confirm target deck (created via `createDeck` if missing; supports `Parent::Child`).
- `modelNames` → confirm the note type name.
- `addNote` (single) or `addNotes` (batch, up to 100, partial success supported) with the deck, model name, and per-note `fields` + `tags`.

MCP creation example — type-in-the-answer card:
```
addNotes(deck: "Daily::Dev", model: "Basic (type in the answer)", notes: [
  {
    fields: {
      "Front": "In Docker, how do you run a container from an image named <code>&lt;imageName&gt;</code> in the background and publish container port 80 to host port 88?",
      "Back": "docker container run --detach --publish 88:80 &lt;imageName&gt;",
      "More info": "&lt;b&gt;--detach&lt;/b&gt; (or -d) runs in background. &lt;b&gt;--publish&lt;/b&gt; (or -p) maps host:container ports."
    },
    tags: ["docker", "commands"]
  }
])
```

Cloze example:
```
addNote(deck: "Daily::Dev", model: "Cloze", fields: {
  "Text": "In {{c2::open addressing}}, collisions are handled by {{c1::probing for another empty location within the hash table}}.",
  "Extra": ""
}, tags: ["dsa", "hash-tables"])
```

### Searching & inspecting

- `findNotes(query)` — Anki query syntax: `deck:`, `tag:`, `is:due`, `is:new`, `added:7`, `front:hello`, `flag:1`, `prop:due<=2`, `OR`, `deck:.. tag:..` (AND).
- `notesInfo(notes)` — full field/tag/CSS detail (CSS-aware; check styling before edits).
- `getTags` — full tag list (use first to avoid duplication).
- `deckStats` — per-deck counts and ease/interval distributions.

### Updating

- `updateNoteFields(note)` — HTML-aware field updates (remember the Browser caveat in Critical Rules).
- `addTags` / `removeTags` / `replaceTags` — tag management.
- `changeDeck` — move cards to another deck (created if missing).
- `deleteNotes(notes, confirmDeletion: true)` — destructive, confirm first.

### Media (images / audio)

- `storeMediaFile` — upload from a **file path** (fast) or **URL** (direct download); avoid base64 (slow, token-heavy).
- `retrieveMediaFile` — download a media file as base64.
- `getMediaFilesNames` — list media, optionally filtered by pattern.
- Media imports are MIME-validated (images/audio/video); `MEDIA_IMPORT_DIR` / `MEDIA_ALLOWED_HOSTS` can restrict sources.

### Model & card-style management

- `modelNames`, `modelFieldNames`, `modelStyling`, `modelTemplates` — inspect note types, fields, CSS, and templates.
- `createModel` — new note type with custom fields/templates/CSS (e.g., RTL styling).
- `updateModelStyling`, `updateModelTemplates` — restyle an existing note type (applies to all its cards).
- `addModelField`, `removeModelField` (confirm required), `renameModelField` (templates referencing old name must be updated separately), `repositionModelField`.

### GUI tools (note editing / deck management only)

`guiBrowse`, `guiSelectCard`, `guiSelectedNotes`, `guiAddCards`, `guiEditNote`,
`guiDeckOverview`, `guiDeckBrowser`, `guiCurrentCard`, `guiShowQuestion`,
`guiShowAnswer`, `guiUndo`. Use for editing/creation and deck workflows — **not** for review sessions.

### Read-only safety

The server supports `--read-only` (or `READ_ONLY=true`): all reads and review work, but content
modifications are blocked. Useful for exploring without risk.

## Python Patterns

The `anki` Python library — use when **Anki is closed** (e.g., large batch imports, deep
collection access). The collection path is:

```
/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2
```

### Getting a Model by ID
```python
from anki.collection import Collection

col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')

basic           = col.models.get(1474753065065)  # Basic
basic_rev       = col.models.get(1474753065064)  # Basic (and reversed card)
type_answer     = col.models.get(1534963187027)  # Basic (type in the answer)
type_multi      = col.models.get(1593528272757)  # Basic (multiline type in the answer and more)
type_answer_simple = col.models.get(1591574768074)  # Basic (type in the answer and more)
basic_rev_more  = col.models.get(1593178485121)  # Basic (and reverse and more)
basic_code      = col.models.get(1509511317335)  # Basic_code
code_output     = col.models.get(1389083022927)  # Code output question
cmd_question    = col.models.get(1581571617476)  # CommandQuestion
cloze           = col.models.get(1474753065059)  # Cloze
latex_back      = col.models.get(1631863082334)  # latex back
latex_front_back = col.models.get(1631863428212) # latex front & back

col.close()
```

### Listing Available Decks
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')
decks = col.decks.all_names_and_ids()
for d in sorted(decks, key=lambda x: x.name):
    print(f"  {d.id} - {d.name}")
col.close()
```

### Listing Cards in a Deck
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')
nids = sorted(col.find_notes('deck:"DeckName"'))
for nid in nids:
    note = col.get_note(nid)
    print(f"Note ID: {note.id}")
    print(f"Type: {note.note_type()['name']}")
    for i, field_name in enumerate(note.note_type()['flds']):
        val = note.fields[i]
        print(f"  {field_name['name']}: {val[:300]}")
    print(f"Tags: {note.tags}")
    print()
col.close()
```

### Creating Cards — Type in the Answer
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')

decks = col.decks.all_names_and_ids()
deck_id = next(d.id for d in decks if d.name == "Daily::Dev")

model = col.models.get(1534963187027)  # Basic (type in the answer)

note = col.new_note(model)
note.fields[0] = "In Docker, how do you run a container from an image named <code>&lt;imageName&gt;</code> in the background and publish container port 80 to host port 88?"
note.fields[1] = "docker container run --detach --publish 88:80 &lt;imageName&gt;"
note.fields[2] = "&lt;b&gt;--detach&lt;/b&gt; (or -d) runs in background. &lt;b&gt;--publish&lt;/b&gt; (or -p) maps host:container ports."
note.tags = ["docker", "commands"]

col.add_note(note, deck_id)
col.close()
```

### Creating Cards — Cloze
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')

decks = col.decks.all_names_and_ids()
deck_id = next(d.id for d in decks if d.name == "Daily::Dev")

model = col.models.get(1474753065059)  # Cloze

note = col.new_note(model)
note.fields[0] = "In {{c2::open addressing}}, collisions are handled by {{c1::probing for another empty location within the hash table}}."
note.fields[1] = ""  # Extra (can leave empty or add explanation)
note.tags = ["dsa", "hash-tables"]

col.add_note(note, deck_id)
col.close()
```

### Creating Cards — Basic (standard one-way)
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')

decks = col.decks.all_names_and_ids()
deck_id = next(d.id for d in decks if d.name == "Daily::Dev")

model = col.models.get(1474753065065)  # Basic

note = col.new_note(model)
note.fields[0] = "In Python, what does <code>zip()</code> do?"
note.fields[1] = "Combines multiple iterables element-wise into tuples.<br /><br />Example:<br /><code>list(zip([1,2], ['a','b'])) → [(1,'a'), (2,'b')]</code>"
note.tags = ["python", "builtins"]

col.add_note(note, deck_id)
col.close()
```

### Creating Cards — Basic + Reversed
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')

decks = col.decks.all_names_and_ids()
deck_id = next(d.id for d in decks if d.name == "Daily::Dev")

model = col.models.get(1474753065064)  # Basic (and reversed card)

note = col.new_note(model)
note.fields[0] = "In HTML, what tag displays a scalar value within a known range (like a gauge)?"
note.fields[1] = "The <code>&lt;meter&gt;</code> tag displays a scalar value within a known range — e.g. disk usage, battery level, or test score.<br /><br />Example:<br /><code>&lt;meter value=\"0.6\"&gt;60%&lt;/meter&gt;</code>"
note.tags = ["html", "tags"]

col.add_note(note, deck_id)
col.close()
```

### Creating Cards — Code Output Question
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')

decks = col.decks.all_names_and_ids()
deck_id = next(d.id for d in decks if d.name == "Daily::Dev")

model = col.models.get(1389083022927)  # Code output question

note = col.new_note(model)
note.fields[0] = """<table style="color:#222; font-size: 19px;"><tbody><tr><td><div class="highlight" style="background: #fbf1c7; padding-left:8px; padding-right:8px;"><pre style="line-height: 125%;"><span style="color: #9D0006">def</span> <span style="color: #427B58">f</span>():
    x = <span style="color: #9D0006">yield</span> <span style="color: #8F3F71">1</span>
    y = <span style="color: #9D0006">yield</span> x
    <span style="color: #9D0006">yield</span> x + y

g = f()

<span style="color: #AF3A03">print</span>(<span style="color: #AF3A03">next</span>(g))
<span style="color: #AF3A03">print</span>(g.send(<span style="color: #8F3F71">4</span>))
<span style="color: #AF3A03">print</span>(g.send(<span style="color: #8F3F71">6</span>))
</pre></div></td></tr></tbody></table>"""
note.fields[1] = "<font color=\"#0000ff\">1<br>4<br>10</font>"  # Output
note.tags = ["python", "generators"]

col.add_note(note, deck_id)
col.close()
```

### Updating Existing Cards
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')

note = col.get_note(NOTE_ID)
note.fields[0] = "New front text"
note.fields[1] = "New back text"
# For notes with more fields:
# note.fields[2] = "New more info"
note.tags.append("new-tag")
col.update_note(note)

col.close()
```

### Tagging Cards
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')

nids = col.find_notes('deck:"Daily::Dev"')
for nid in nids:
    note = col.get_note(nid)
    if "desired-tag" not in note.tags:
        note.tags.append("desired-tag")
        col.update_note(note)

col.close()
```

### Deleting Cards
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')
col.remove_notes([NOTE_ID_1, NOTE_ID_2])
col.close()
```

### Changing Note Type (e.g., Basic → Basic + Reversed)
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')

old_model = col.models.get(1474753065065)   # Basic
new_model = col.models.get(1474753065064)   # Basic (and reversed card)

nids = [...]  # list of note IDs to change
# field_map: Front(0)→Front(0), Back(1)→Back(1)
# card_map: Card1(0)→Card1(0) — reverse Card2 will be auto-created
col.models.change(old_model, nids, new_model, {0: 0, 1: 1}, {0: 0})

col.close()
```

### Searching Notes
```python
col = Collection('/Users/tomasortega/Library/Application Support/Anki2/User 1/collection.anki2')

# Search by deck (use :: for subdecks)
nids = col.find_notes('deck:"Daily::Dev"')

# Search by tag
nids = col.find_notes('tag:regex')

# Search by content (quotes for phrase match)
nids = col.find_notes('"some text"')

# Combine searches
nids = col.find_notes('deck:"Daily::Dev" tag:python')

col.close()
```

## Workflow

When asked to add, manage, or review cards, follow this process:

1. **Check which interface is available:**
   - Test AnkiConnect: `curl -s -m 3 -X POST http://localhost:8765 -d '{"action":"version","version":6}'`
   - Check if Anki is running: `ps aux | grep -i "anki.app" | grep -v grep | grep -v voicebanking`
   - AnkiConnect reachable → use **MCP tools**. Otherwise → use the **Python library** (Anki closed).
2. **Review/study request?** Use the MCP review flow (`get_due_cards` → `present_card` → `rate_card`). Anki must be running.
3. **If adding to a deck**, list available decks first (`listDecks` or Python) and confirm the target deck with the user if ambiguous.
4. **Choose the right note type** using the Note Type Decision Guide above:
   - Commands / exact syntax → `Basic (type in the answer)` or `CommandQuestion`
   - What does this code output → `Code output question`
   - Fill-in-the-blank → `Cloze`
   - Code explanation questions → `Basic_code`
   - LaTeX math → `latex front & back` / `latex back`
   - Bidirectional concepts → `Basic (and reversed card)`
   - Everything else → `Basic`
5. **If creating cards from user-provided content:**
   a. Parse the information the user provides.
   b. Generate well-formed card fronts and backs following the guidelines above.
   c. Choose the optimal note type for each card based on its content.
   d. Ask the user to confirm the cards look good (show a preview) before writing, unless there are many and it would be impractical.
   e. Create the cards with appropriate tags (via `addNote`/`addNotes`, or the Python library).
6. **If improving existing cards**, show the user what changes will be made (use `findNotes`/`notesInfo` or `get_note` first).
7. **Verify** by reading back the created/updated cards (`notesInfo` or `get_note`).
8. **Close the collection** when using the Python library and tell the user they can reopen Anki. AnkiConnect needs no cleanup.
